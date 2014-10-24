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
  
  Query(this.repo_path, Map bean) : super(bean);
  
  
  
  bool get predefined => get(predefined_field);
  
  
  Query clone() {
    return new Query(repo_path, new Map.from(bean));
  }
  
  //calculates endpoint
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
  
  
  
  
  List<String> get parameters {
  
     List<String> params = [];
     
     String exp = bean[Query.expression_field];
     
     for (Match m in regexp.allMatches(exp))
       params.add(m.group(1));
     
     return params;
     
  
   }
}

abstract class Queries extends ListItems<EditableModel<Query>> {
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
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData).catchError((e)=>_onError(e, loadAll));
  }
  
  void _setData(List<Query> items) {

    storage.data.clear();

    storage.data.addAll(items.map((Query q)=> new EditableModel(q)));
    storage.loading = false;
    
  }
  
  
  void _onError(e, callback) {
    storage.data.clear();
    storage.loading = false;
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

class EditableModel<T extends Cloneable<T>> extends Observable with ListItem {
  
  @observable
  bool edit = false;
  
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

}

abstract class Cloneable<T> {
  
  T clone();
}



