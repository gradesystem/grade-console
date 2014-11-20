part of queries;

class Query extends EditableGradeEntity with Filters {
  
  static String id_field = "http://gradesystem.io/onto#id";
  static String endpoint_field = "http://gradesystem.io/onto/query.owl#endpoint";
  static String datasets_field="http://gradesystem.io/onto/query.owl#datasets";
  static String name_field = "http://gradesystem.io/onto/query.owl#name";  
  static String note_field= "http://gradesystem.io/onto/query.owl#note";
  static String target_field="http://gradesystem.io/onto/query.owl#target";
  static String expression_field="http://gradesystem.io/onto/query.owl#expression";
  static String parameters_field="http://gradesystem.io/onto/query.owl#parameters";
  static String predefined_field="http://gradesystem.io/onto/query.owl#predefined";
  
  static final RegExp regexp = new RegExp(r"!(\w+)");

  final String repo_path;
  
  Query.fromBean(this.repo_path, Map bean) : super(bean){
    
    _listenChanges();
  }
  
  Query(this.repo_path) : super({}) {
    put(name_field, "");
    put(expression_field, "");
    put(predefined_field, false);
     
    _listenChanges();
  }
  
  void _listenChanges() {
    onBeanChange([name_field, expression_field], ()=>notifyPropertyChange(#endpoint, null, endpoint) );
    onBeanChange([expression_field], ()=>notifyPropertyChange(#parameters, null, parameters) );
    onBeanChange([name_field], ()=>notifyPropertyChange(#name, null, name) );
  }
  
  String get id => get(id_field);
  set id(String value) => set(id_field, value);
  
  String get name => get(name_field);
  set name(String value) {
    set(name_field, value);
  }
  
  bool get predefined => get(predefined_field);
  
  
  Query clone() {
    return new Query.fromBean(repo_path, new Map.from(bean));
  }
  
  //calculates endpoint
  @observable
  String get endpoint  {

    Map<String,String> endpointParameters = {};
    for (String parameter in parameters) endpointParameters[parameter]="...";
    
    Uri uri = new Uri.http("", '../service/${repo_path}/query/${bean[name_field]}/results', endpointParameters);
    
    String endpoint = uri.toString();
    
    //we remove the schema
    endpoint = endpoint.substring(5);
    
    //we remove the final question mark
    if (endpoint.endsWith("?")) endpoint = endpoint.substring(0, endpoint.length-1);
    
    return endpoint;

  }
  
  @observable
  List<String> get parameters {
  
     List<String> params = [];
     
     String exp = bean[Query.expression_field];
     
     for (Match m in regexp.allMatches(exp))
       params.add(m.group(1));
     
     return params;
     
  
   }
}

abstract class Queries extends EditableListItems<EditableQuery> {
  
  bool containsName(String name) => data.any((EditableQuery eq)=>eq!=selected && eq.model.name!=null && eq.model.name.toLowerCase() == name.toLowerCase());
}

abstract class QuerySubPageModel extends SubPageEditableModel<Query> {
  


  
  QuerySubPageModel(EventBus bus, QueryService service, Queries storage):super(bus, service, storage, 
      ([Query query])=>generate(query!=null?query:new Query(service.path))){
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
  
  static EditableQuery generate(Query query) {
    //we are cloning
    if (query.id == null) query.bean[Query.predefined_field] = false;
    return new EditableQuery(query);
  }
  
  QueryService get queryService => service;

  void runQueryByName(EditableQuery editableQuery) {
    editableQuery.runQuery();
    
    queryService.runQueryByName(editableQuery.model, editableQuery.parametersValues)
      .then((QueryResult r)=>editableQuery.queryResult(r))
      .catchError((e)=> editableQuery.queryFailed(e));
  }
  
  void runQuery(EditableQuery editableQuery) {
    editableQuery.runQuery();
    queryService.runQuery(editableQuery.model, editableQuery.parametersValues)
    .then((QueryResult r)=>editableQuery.queryResult(r))
    .catchError((e)=>editableQuery.queryFailed(e));
  }
}

class EditableQuery extends EditableModel<Query> {
  
  @observable
  bool queryRunning = false;
  
  @observable
  ErrorResponse lastError;
  
  @observable
  QueryResult lastQueryResult;
  
  @observable
  ObservableMap<String,String> parametersValues = new ObservableMap();
  
  @observable
  ObservableMap<String,bool> parametersInvalidity = new ObservableMap();
  
  bool _validParameters = true;
  
  bool _dirty = false;
  
  EditableQuery(Query query):super(query) {
    //we want to listen on parameters value changes
    parametersInvalidity.changes.listen(_updateParametersValidity);
    
    parametersValues.changes.listen((_)=>_setDirty(true));
    
    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);
    
    //when query or parameters are edited we reset the last error
    onPropertyChange(this, #dirty, resetLastError);
    
  }
  
  void _listenNewModel() {
    //when parameters list change we re-calculate the parameters validity
    onPropertyChange(model, #parameters, ()=>_updateParametersValidity(null));
    _updateParametersValidity(null);

    model.changes.listen((_)=>_setDirty(true));
    
    onPropertyChange(this, #model, ()=>_setDirty(false));
  }
  
  void _setDirty(bool dirty) {
    _dirty = dirty;
   notifyPropertyChange(#dirty, null, _dirty); 
  }
  
  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;
  
  void resetLastError() {
    lastError = null;
  }
  
  void _updateParametersValidity(_) {
    List<String> parameters = model.parameters;
    _validParameters = parameters.every((String name)=>parametersInvalidity.containsKey(name) && !parametersInvalidity[name]);
    notifyPropertyChange(#validParameters, null, _validParameters);
  }
  
  @observable
  bool get validParameters => _validParameters; 
  
  
  void runQuery() {
    queryRunning = true;
    _setDirty(false);
    resetLastError();
    lastQueryResult = null;
  }
  
  void queryResult(QueryResult result) {
    queryRunning = false;
    lastQueryResult = result;
  }
  
  void queryFailed(ErrorResponse reason) {
    queryRunning = false;
    lastError = reason;
  }
  
}

class QueryResult extends Delegate {
  
  String raw;
  
  QueryResult(this.raw, Map bean):super(bean);
  
  List<String> get headers => get("head")["vars"];
  List<Map<String,String>> get rows => get("results")["bindings"];
}
