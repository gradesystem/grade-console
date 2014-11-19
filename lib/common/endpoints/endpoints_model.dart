part of endpoints;

class Endpoint extends GradeEntity with Cloneable<Endpoint>, Filters {
  
  static String id_field = "http://gradesystem.io/onto#id";  
  static String name_field = "http://gradesystem.io/onto/endpoint.owl#name";  
  static String uri_field= "http://gradesystem.io/onto/endpoint.owl#uri";//FIXME 
  static String update_uri_field= "http://gradesystem.io/onto/endpoint.owl#update_uri";
  static String graphs_field= "http://gradesystem.io/onto/endpoint.owl#graph";
  static String predefined_field="http://gradesystem.io/onto/endpoint.owl#predefined";
  
  Endpoint.fromBean(Map bean) : super(bean){
    
    _listenChanges();
  }
  
  Endpoint() : this.fromBean({
    id_field:"", 
    name_field:"", 
    uri_field:"",
    update_uri_field:"",
    predefined_field:false});
  
  void _listenChanges() {
    onBeanChange([id_field], ()=>notifyPropertyChange(#id, null, id));
    onBeanChange([name_field], ()=>notifyPropertyChange(#name, null, name));
    onBeanChange([uri_field], ()=>notifyPropertyChange(#uri, null, uri));
    onBeanChange([update_uri_field], ()=>notifyPropertyChange(#updateUri, null, updateUri));
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
  
  @observable
  String get updateUri => get(update_uri_field);
  set updateUri(String value) {
    set(update_uri_field, value);
    notifyPropertyChange(#updateUri, null, value);
  }
  
  bool get predefined => get(predefined_field);
  
  @observable
  List<String> get graphs => get(graphs_field);
  set graphs(List<String> newgraphs) {
    set(graphs_field, newgraphs);
    notifyPropertyChange(#graphs, null, newgraphs);
  }
  
  Endpoint clone() {
    return new Endpoint.fromBean(new Map.from(bean));
  }
  
  String toString() => "Endpoint id: $id name: $name uri: $uri updateUri: $updateUri graphs: $graphs hashCode: $hashCode";
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
  
  void removeEndpointGraph(EditableEndpoint editableModel, String graph) {

      Timer timer = new Timer(new Duration(milliseconds: 200), () {
        editableModel.loadingGraphs = true;
      });
      
      service.deleteEndpointGraph(editableModel.model, graph)
      .then((bool result){
        editableModel.model.graphs.remove(graph);
      })
      .catchError((e)=>_onError(e, ()=>removeEndpointGraph(editableModel, graph)))
      .whenComplete((){
        timer.cancel();
        editableModel.loadingGraphs = false;
      });

    }
  
  void addEndpointGraph(EditableEndpoint editableModel, String graph) {
      
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
           editableModel.loadingGraphs = true;
         });
           
    service.addEndpointGraph(editableModel.model, graph)
    .then((bool result){
      editableModel.model.graphs.add(graph);
    })
    .catchError((e)=>_onError(e, ()=>addEndpointGraph(editableModel, graph)))
    .whenComplete((){
      timer.cancel();
      editableModel.loadingGraphs = false;
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
  
  String toString() => "EditableEndpoint model: $model";

}


class GradeEnpoints extends Observable {
  
  ObservableList<AreaEndpoints> areaEndpoints = new ObservableList();
  ObservableList<GradeEndpoint> union = new ObservableList();
  
  void addList(Endpoints endpointsStorage, Refresh refresh, String area) {
    areaEndpoints.add(new AreaEndpoints(endpointsStorage, refresh, area));
    onPropertyChange(endpointsStorage, #synchedData, updateUnion);
  }
  
  void updateUnion() {
    union.clear();
   
    //list.skipWhile((GradeEndpoint e)=>e.editableEndpoint.newModel)
    areaEndpoints.forEach((AreaEndpoints areaEndpoints){ 
      union.addAll(areaEndpoints.endpointsStorage.synchedData.map((EditableEndpoint e)=> new GradeEndpoint(e, areaEndpoints.refresh, areaEndpoints.area)));
    });
    
    notifyPropertyChange(#items, null, items);
  }
  
  ObservableList<GradeEndpoint> get items => union;
  
  GradeEndpoint find(String id) => union.firstWhere((GradeEndpoint e) => e.editableEndpoint.model.id == id, orElse:()=>null);
  
  //remove after model update
  GradeEndpoint findByURI(String uri) => union.firstWhere((GradeEndpoint e) => e.editableEndpoint.model.uri == uri, orElse:()=>null);
}

typedef void Refresh(EditableEndpoint);

class AreaEndpoints {
  Endpoints endpointsStorage;
  Refresh refresh;
  String area;
  
  AreaEndpoints(this.endpointsStorage, this.refresh, this.area);
  
  
    
}

class GradeEndpoint extends Observable {
  EditableEndpoint editableEndpoint;
  Refresh _refresh;
  String area;
  
  GradeEndpoint(this.editableEndpoint, this._refresh, this.area);
  
  void refresh() {
    _refresh(editableEndpoint);
  }
  
  String toString() => "GradeEndpoint editableEndpoint: $editableEndpoint";
}
