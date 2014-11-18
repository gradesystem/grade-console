part of endpoints;

class Endpoint extends GradeEntity with Cloneable<Endpoint>, Filters {
  
  static String id_field = "http://gradesystem.io/onto#id";  
  static String name_field = "http://gradesystem.io/onto/endpoint.owl#name";  
  static String uri_field= "http://gradesystem.io/onto/endpoint.owl#uri";
  static String graphs_field= "http://gradesystem.io/onto/endpoint.owl#graph";
  static String graphs_last_update_field= "http://gradesystem.io/onto/endpoint.owl#graphs_last_update";
  static String predefined_field="http://gradesystem.io/onto/endpoint.owl#predefined";
  
  Endpoint.fromBean(Map bean) : super(bean){
    
    _listenChanges();
  }
  
  Endpoint() : this.fromBean({
    id_field:"", 
    name_field:"", 
    uri_field:"", 
    predefined_field:false});
  
  void _listenChanges() {
    onBeanChange([id_field], ()=>notifyPropertyChange(#id, null, id));
    onBeanChange([name_field], ()=>notifyPropertyChange(#name, null, name));
    onBeanChange([uri_field], ()=>notifyPropertyChange(#uri, null, uri));
    onBeanChange([graphs_field], ()=>notifyPropertyChange(#graphs, null, graphs));
  }
  
  @observable
  String get id => get(id_field);
  set id(String value) {
    set(id_field, value);
    notifyPropertyChange(#id, null, value);
  }
  
  @observable
  String get name => get(name_field);
  set name(String value) {
    set(name_field, value);
    notifyPropertyChange(#name, null, value);
  }
   
  @observable
  String get uri => get(uri_field);
  set uri(String value) {
    set(uri_field, value);
    notifyPropertyChange(#uri, null, value);
  }
  
  bool get predefined => get(predefined_field);
  
  @observable
  List<String> get graphs => get(graphs_field);
  set graphs(List<String> newgraphs) {
    set(graphs_field, newgraphs);
    graphsLastUpdate = Filters.formatter.format(new DateTime.now()); 
    notifyPropertyChange(#graphs, null, newgraphs);
  }
  
  @observable
  String get graphsLastUpdate => get(graphs_last_update_field);
  set graphsLastUpdate(String graphsLastUpdate) {
      set(graphs_last_update_field, graphsLastUpdate);
      notifyPropertyChange(#graphsLastUpdate, null, graphsLastUpdate);
  }
  
  Endpoint clone() {
    return new Endpoint.fromBean(new Map.from(bean));
  }
  
  String toString() => "Endpoint id: $id name: $name ur: $uri graphs: $graphs hashCode: $hashCode";
}

abstract class Endpoints extends EditableListItems<EditableEndpoint> {
  
  bool containsName(String name) => data.any((EditableEndpoint eq)=>eq!=selected && eq.model.name!=null && eq.model.name.toLowerCase() == name.toLowerCase());
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
    Endpoint endpoint = new Endpoint();
    EditableEndpoint editableModel = new EditableEndpoint(endpoint);
    editableModel.newModel = true;
    
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  void cancelEditing(EditableEndpoint endpoint) {
    endpoint.cancel();
    if (endpoint.newModel) {
      storage.selected = null;
      storage.data.remove(endpoint);
    }
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
    
    service.put(editableModel.model)
    .then((Endpoint result)=> editableModel.save(result))
    .catchError((e)=>_onError(e, ()=>saveEndpoint(editableModel)))
    .whenComplete((){
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void refreshGraphs(EditableEndpoint editableModel) {
    
    editableModel.loadingGraphs = true;
    Endpoint endpoint = editableModel.model; 
    print('refreshing $endpoint');
    service.get(endpoint.name)
    .then((Endpoint result){endpoint.graphs = result.graphs;})
    .catchError((e)=>_onError(e, ()=>refreshGraphs(editableModel)))
    .whenComplete((){
      editableModel.loadingGraphs = false;
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
    log.warning("EndpointsModel error: $e");
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

class EditableEndpoint extends EditableModel<Endpoint> {

  @observable
  bool loadingGraphs = false;
  
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
  
  String toString() => "EditableEndpoint loadingGraphs: $loadingGraphs ${super.toString()}";

}


class GradeEnpoints extends Observable {
  
  ObservableList<AreaEndpoints> areaEndpoints = new ObservableList();
  ObservableList<GradeEndpoint> union = new ObservableList();
  
  void addList(ObservableList<EditableEndpoint> endpoints, Refresh refresh, String area) {
    areaEndpoints.add(new AreaEndpoints(endpoints, refresh, area));
    endpoints.listChanges.forEach((_){updateUnion();});
  }
  
  void updateUnion() {
    union.clear();
   
    //list.skipWhile((GradeEndpoint e)=>e.editableEndpoint.newModel)
    areaEndpoints.forEach((AreaEndpoints areaEndpoints){ 
      union.addAll(areaEndpoints.endpoints.map((EditableEndpoint e)=> new GradeEndpoint(e, areaEndpoints.refresh, areaEndpoints.area)));
    });
    
    notifyPropertyChange(#items, null, items);
  }
  
  ObservableList<GradeEndpoint> get items => union;
  
  GradeEndpoint find(String id) => union.firstWhere((GradeEndpoint e) => e.id == id, orElse:()=>null);
  
  //remove after model update
  GradeEndpoint findByURI(String uri) => union.firstWhere((GradeEndpoint e) => e.uri == uri, orElse:()=>null);
}

typedef void Refresh(EditableEndpoint);

class AreaEndpoints {
  ObservableList<EditableEndpoint> endpoints;
  Refresh refresh;
  String area;
  
  AreaEndpoints(this.endpoints, this.refresh, this.area);
    
}

class GradeEndpoint extends Observable {
  EditableEndpoint editableEndpoint;
  Refresh _refresh;
  String area;
  
  GradeEndpoint(this.editableEndpoint, this._refresh, this.area) {
    onPropertyChange(editableEndpoint, #loadingGraphs, ()=>notifyPropertyChange(#loadingGraphs, null, loadingGraphs));
    onPropertyChange(endpoint, #graphs, ()=>notifyPropertyChange(#graphs, null, graphs));
    
    //maybe avoid the bridge?
    onPropertyChange(endpoint, #id, ()=>notifyPropertyChange(#id, null, id));
    onPropertyChange(endpoint, #uri, ()=>notifyPropertyChange(#uri, null, uri));
  }
  
  String get id => endpoint.id;
  
  String get uri => endpoint.uri;
  
  Endpoint get endpoint => editableEndpoint.model;
  
  @observable
  List<String> get graphs => endpoint.graphs;
  
  void refresh() {
    _refresh(editableEndpoint);
  }
  
  @observable
  bool get loadingGraphs => editableEndpoint.loadingGraphs;
  
}
