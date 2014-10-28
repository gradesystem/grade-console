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
}

abstract class QuerySubPageModel {
  
  EventBus bus;
  QueryService service;
  Queries storage;
  
  QuerySubPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
  
  void addNewQuery() {
    Query query = new Query(service.path);
    EditableQuery editableModel = new EditableQuery(query);
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void saveQuery(EditableQuery editableModel) {
    editableModel.sync();
    service.put(editableModel.model)
    .then((bool result){saveComplete(result, editableModel);})
    .catchError((e)=>_onError(e, (){saveQuery(editableModel);}))
    .whenComplete((){editableModel.synched();});

    new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });
  }
  
  void saveComplete(bool result, EditableQuery editableModel) {
    editableModel.save();
  }
  
  void runQueryByName(EditableQuery editableQuery) {
    editableQuery.queryRunning = true;
    service.runQueryByName(editableQuery.model, editableQuery.parametersValues).then((QueryResult r){ 
      editableQuery.lastQueryResult = r;
      editableQuery.queryRunning = false;
    });
  }
  
  void runQuery(EditableQuery editableQuery) {
    editableQuery.queryRunning = true;
    service.runQuery(editableQuery.model, editableQuery.parametersValues).then((QueryResult r){ 
      editableQuery.lastQueryResult = r;
      editableQuery.queryRunning = false;
    });
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
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

class EditableQuery extends EditableModel<Query> {
  
  bool queryRunning;
  
  @observable
  QueryResult lastQueryResult;
  
  Map<String,String> parametersValues = {};
  
  EditableQuery(Query query):super(query);
  
  
}

class EditableModel<T extends Cloneable<T>> extends Observable with ListItem {
  
  @observable
  bool edit = false;
  
  @observable
  bool synching = false;
  
  T _original;
  T _underEdit;
  
  EditableModel(this._original);
  
  @observable
  T get model => edit?_underEdit:_original;
  
  void startEdit() {
    edit = true;
    _underEdit = _original.clone();
    
    notifyPropertyChange(#model, _original, _underEdit);
  }
  
  void cancel() {
    edit = false;
    notifyPropertyChange(#model, _underEdit, _original);
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
