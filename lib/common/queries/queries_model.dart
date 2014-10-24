part of queries;

class Query extends Delegate with ListItem, Cloneable<Query>, Observable {
  
  static String endpoint_field = "http://gradesystem.io/onto/query.owl#endpoint";
  static String name_field = "http://gradesystem.io/onto/query.owl#name";  
  static String note_field= "http://gradesystem.io/onto/query.owl#note";
  static String target_field="http://gradesystem.io/onto/query.owl#target";
  static String expression_field="http://gradesystem.io/onto/query.owl#expression";
  static String predefined_field="http://gradesystem.io/onto/query.owl#predefined";
   
    
  Query(this.repo_path, Map bean) : super(new ObservableMap.from(bean));
   
  final String repo_path;

  @observable
  String get name => this.get(name_field);
  void set name(String value) {this.set(name_field, value);}
    
  String get endpoint => '../service/${repo_path}/query/${bean[name_field]}/results';
  
  bool get predefined => get(predefined_field);
  
  Query clone() {
    return new Query(repo_path, new Map.from(bean));
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
  
  void dump() {
    if (_original!=null) print('_original ${_original.bean}');
    else print('_original null');
    if (_underEdit!=null) print('_underEdit ${_underEdit.bean}');
    else print('_underEdit null');
  }

}

abstract class Cloneable<T> {
  
  T clone();
}



