part of endpoints;

class Endpoint extends Delegate with Cloneable<Endpoint>, Observable, Filters {
  
  static String name_field = "http://gradesystem.io/onto/endpoint.owl#name";  
  static String uri_field= "http://gradesystem.io/onto/endpoint.owl#uri";
  static String predefined_field="http://gradesystem.io/onto/endpoint.owl#predefined";
  
  Endpoint.fromBean(Map bean) : super(bean){
    
    _listenChanges();
  }
  
  Endpoint() : this.fromBean({
    name_field:"", 
    uri_field:"", 
    predefined_field:false});
  
  void _listenChanges() {
    onBeanChange([name_field], ()=>notifyPropertyChange(#name, null, name) );
    onBeanChange([uri_field], ()=>notifyPropertyChange(#uri, null, uri) );
  }
  
  
  String get name => get(name_field);
  set name(String value) {
    set(name_field, value);
  }
  
  String get uri => get(uri_field);
  set uri(String value) {
    set(uri_field, value);
  }
  
  bool get predefined => get(predefined_field);
  
  
  Endpoint clone() {
    return new Endpoint.fromBean(new Map.from(bean));
  }
}

abstract class Endpoints extends ListItems<EditableEndpoint> {
  
  bool containsName(String name) => data.any((EditableEndpoint eq)=>eq!=selected && eq.model.name.toLowerCase() == name.toLowerCase());
}

abstract class EndpointSubPageModel {
  
  EventBus bus;
  EndpointsService service;
  Endpoints storage;
  
  EndpointSubPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
  
  void addNewEndpoint() {
    Endpoint query = new Endpoint();
    EditableEndpoint editableModel = new EditableEndpoint(query);
    editableModel.newModel = true;
    
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void cancelEditing(EditableEndpoint query) {
    query.cancel();
    if (query.newModel) storage.data.remove(query);
  }
  
  void cloneEndpoint(EditableEndpoint original) {
    Endpoint cloned = original.model.clone();
    cloned.name = cloned.name + "_cloned";
    EditableEndpoint editableModel = new EditableEndpoint(cloned);
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void saveEndpoint(EditableEndpoint editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });
    
    service.putEndpoint(editableModel.model)
    .then((bool result)=>editableModel.save())
    .catchError((e)=>_onError(e, ()=>saveEndpoint(editableModel)))
    .whenComplete((){
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void removeEndpoint(EditableEndpoint editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });
    
    service.deleteEndpoint(editableModel.model)
    .then((bool result){
      storage.data.remove(editableModel);
      storage.selected = null;
    })
    .catchError((e)=>_onError(e, ()=>saveEndpoint(editableModel)))
    .whenComplete((){
      timer.cancel();
      editableModel.synched();
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
  
  void _setData(List<Endpoint> items) {

    storage.data.clear();

    storage.data.addAll(items.map((Endpoint q)=> new EditableEndpoint(q)));
    storage.loading = false;
    
  }
  
  void _onError(e, callback) {
    log.warning("QueryModel error: $e");
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

class EditableEndpoint extends EditableModel<Endpoint> {
  
  bool _validParameters = true;
  
  bool _dirty = false;
  
  EditableEndpoint(Endpoint query):super(query) {
    
    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);
   
  }
  
  void _listenNewModel() {

    model.changes.listen((_)=>_setDirty(true));
    
    onPropertyChange(this, #model, ()=>_setDirty(false));
  }
  
  void _setDirty(bool dirty) {
    _dirty = dirty;
   notifyPropertyChange(#dirty, null, _dirty); 
  }
  
  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;

}

