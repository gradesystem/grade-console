part of queries;

class Query extends Delegate with ListItem, Cloneable<Query>, Observable, Filters {
  
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
    
    String endpoint = '../service/${repo_path}/query/${bean[name_field]}/results';
  
    List<String> parameters = this.parameters;
    
    if (!parameters.isEmpty) {
      
      endpoint = "${endpoint}?";
    
      for (String param in parameters)
        endpoint = endpoint.endsWith("?")?"${endpoint}${param}=...":"${endpoint}&${param}=..."; 
    
   }
    
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

abstract class Queries extends ListItems<EditableQuery> {
  
  bool containsName(String name) => data.any((EditableQuery eq)=>eq!=selected && eq.model.name == name);
}

abstract class QuerySubPageModel {
  
  EventBus bus;
  QueryService service;
  Queries storage;
  QueryValidator validator;
  
  QuerySubPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
    validator = new QueryValidator(storage);
  }
  
  void addNewQuery() {
    Query query = new Query(service.path);
    EditableQuery editableModel = new EditableQuery(query);
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void cloneQuery(EditableQuery original) {
    Query cloned = original.model.clone();
    cloned.name = cloned.name + "_cloned";
    EditableQuery editableModel = new EditableQuery(cloned);
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void saveQuery(EditableQuery editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });
    
    service.putQuery(editableModel.model)
    .then((bool result)=>editableModel.save())
    .catchError((e)=>_onError(e, ()=>saveQuery(editableModel)))
    .whenComplete((){
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void removeQuery(EditableQuery editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });
    
    service.deleteQuery(editableModel.model)
    .then((bool result){
      storage.data.remove(editableModel);
      storage.selected = null;
    })
    .catchError((e)=>_onError(e, ()=>saveQuery(editableModel)))
    .whenComplete((){
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void runQueryByName(EditableQuery editableQuery) {
    editableQuery.runQuery();
    
    service.runQueryByName(editableQuery.model, editableQuery.parametersValues)
      .then((QueryResult r)=>editableQuery.queryResult(r))
      .catchError((e)=> editableQuery.queryFailed(e.toString()));
  }
  
  void runQuery(EditableQuery editableQuery) {
    editableQuery.runQuery();
    service.runQuery(editableQuery.model, editableQuery.parametersValues)
    .then((QueryResult r)=>editableQuery.queryResult(r))
    .catchError((e)=> editableQuery.queryFailed(e.toString()));
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData).catchError((e){
      _onError(e, loadAll);
      storage.data.clear();
      storage.loading = false;
      }
    );
  }
  
  void _setData(List<Query> items) {

    storage.data.clear();

    storage.data.addAll(items.map((Query q)=> new EditableQuery(q)));
    storage.loading = false;
    
  }
  
  void _onError(e, callback) {
    log.warning("QueryModel error: $e");
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

class EditableQuery extends EditableModel<Query> {
  
  @observable
  bool queryRunning = false;
  
  @observable
  String lastError;
  
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
    onPropertyChange(this, #dirty, (){if (dirty) resetLastError();});
    
  }
  
  void _listenNewModel() {
    //when parameters list change we re-calculate the parameters validity
    onPropertyChange(model, #parameters, ()=>_updateParametersValidity(null));
    _updateParametersValidity(null);

    model.changes.listen((_)=>_setDirty(true));
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
  
  void queryFailed(String reason) {
    queryRunning = false;
    lastError = reason;
  }
  
}

class EditableModel<T extends Cloneable<T>> extends Observable with ListItem {
  
  @observable
  bool edit = false;
  
  @observable
  bool synching = false;

  @observable
  ObservableMap<String,bool> fieldsInvalidity = new ObservableMap();
  
  bool _valid = true;
  
  T _original;
  T _underEdit;
  
  EditableModel(this._original) {
    fieldsInvalidity.changes.listen(_updateValidity);
  }
  
  void _updateValidity(_) {
    _valid = fieldsInvalidity.values.every((b)=>!b);
    notifyPropertyChange(#valid, null, _valid);
  }
  
  @observable
  T get model => edit?_underEdit:_original;
  
  @observable
  bool get valid => _valid; 
  
  void startEdit() {
    edit = true;
    _underEdit = _original.clone();
    
    notifyPropertyChange(#model, _original, _underEdit);
  }
  
  void cancel() {
    edit = false;
    notifyPropertyChange(#model, _underEdit, _original);
    fieldsInvalidity.clear();
  }
  
  void save() {
    _original = _underEdit;
    edit = false;
    notifyPropertyChange(#model, _underEdit, _original);
  }
  
  void sync() {
    synching = true;
  }
  
  void synched() {
    synching = false;
  }

}

abstract class Cloneable<T> {
  
  T clone();
}

class QueryResult extends Delegate {
  
  String raw;
  
  QueryResult(this.raw, Map bean):super(bean);
  
  List<String> get headers => get("head")["vars"];
  List<Map<String,String>> get rows => get("results")["bindings"];
}

class QueryValidator extends Validator {
  
  static final ValidationResult VALID = new ValidationResult.valid();
  static final ValidationResult EMPTY_VALUE = new ValidationResult.invalid("Please fill out this field.");
  static final ValidationResult NAME_NOT_UNIQUE = new ValidationResult.invalid("Query name already taken");
  
  Queries queries;
  
  QueryValidator(this.queries);
  
  ValidationResult isValid(String key, String value) {
    print('validating key: $key value: $value');
    if (key == Query.name_field && queries.containsName(value)) {
      print('result: $NAME_NOT_UNIQUE');
      return NAME_NOT_UNIQUE;
    }
    ValidationResult result = value.isEmpty?EMPTY_VALUE:VALID;
    
    print('result: $result');
    return result;
    
  }
}
