part of endpoints;

class GraphKeys {

  const GraphKeys();
  
  final String label = "label";
  final String uri = "uri";
  final String size = "size";
}

class Graph extends GradeEntity with Observable {
  
  static GraphKeys K = new GraphKeys();
  
  Graph(String uri, String label) : this.fromBean({K.uri:uri, K.label:label});
  
  Graph.fromBean(Map bean) : super(bean) {
    onBeanChange([K.label], () => notifyPropertyChange(#label, null, label));
  }
  
  String get uri => get(K.uri);
  
  @observable
  String get label => get(K.label);
  set label(String value)  {
    set(K.label, value);
    notifyPropertyChange(#label, null, value);
  }
  
  String get size => get(K.size);
  
  String toString() => "Graph label: $label uri: $uri size: $size";
  
}

class EndpointKeys {

  const EndpointKeys();
  
  final String id = "id";
  final String name = "name";
  final String uri = "uri";
  final String update_uri = "update uri";
  final String graphs = "graph";
  final String locked = "locked";
  final String status = "status";
  final String status_data = "data";
  final String status_system = "system";
}

class Endpoint extends EditableGradeEntity with Filters {

  static EndpointKeys K = const EndpointKeys();

  ObservableList<Graph> _graphs = new ObservableList();
  
  Endpoint.fromBean(Map bean) : super(bean) {
    _syncGraphs();
    _listenChanges();
  }
  
  Endpoint._clone(Map bean) : super(bean) {
    graphs = get(K.graphs);
    bean[K.graphs] = _graphs;
    _listenChanges();
  }

  Endpoint() : this.fromBean({
        K.id: "",
        K.name: "",
        K.uri: "",
        K.update_uri: "",
        K.graphs: [],
        K.status: K.status_data,
        K.locked:false
      });

  void _listenChanges() {
    onBeanChange([K.id], () => notifyPropertyChange(#id, null, id));
    onBeanChange([K.name], () => notifyPropertyChange(#name, null, name));
    onBeanChange([K.uri], () => notifyPropertyChange(#uri, null, uri));
    onBeanChange([K.update_uri], () => notifyPropertyChange(#updateUri, null, updateUri));
    onBeanChange([K.locked], () => notifyPropertyChange(#locked, null, locked));
    onBeanChange([K.status], () {
      notifyPropertyChange(#isSystem, null, isSystem);
      notifyPropertyChange(#isData, null, isData);
    });
    //we don't support graphs in bean map writing
  }
  
  void _syncGraphs() {
    graphs = all(K.graphs, (Map json)=>new Graph.fromBean(json));
    bean[K.graphs] = _graphs;
  }
  
  @observable
  List<Graph> get graphs => _graphs;
  set graphs(List<Graph> newgraphs) {
    _graphs.clear();
    if (newgraphs!=null) _graphs.addAll(newgraphs);
    notifyPropertyChange(#graphs, null, _graphs);
  }

  @observable
  String get id => get(K.id);
  set id(String value) {
    set(K.id, value);
    notifyPropertyChange(#id, null, value);
  }

  @observable
  String get name => get(K.name);
  set name(String value) {
    set(K.name, value);
    notifyPropertyChange(#name, null, value);
  }

  @observable
  String get uri => get(K.uri);
  set uri(String value) {
    set(K.uri, value);
    notifyPropertyChange(#uri, null, value);
  }

  @observable
  String get updateUri => get(K.update_uri);
  set updateUri(String value) {
    set(K.update_uri, value);
    notifyPropertyChange(#updateUri, null, value);
  }
  
  bool get isSystem => get(K.status) == K.status_system;
  bool get isData => get(K.status) == K.status_data;
  
  @observable
  bool get locked => get(K.locked);
  set locked(bool value) {
    set(K.locked, value);
    notifyPropertyChange(#locked, null, locked);
  }

  Endpoint clone() {
    return new Endpoint._clone(new Map.from(bean));
  }

  String toString() => "Endpoint id: $id name: $name uri: $uri updateUri: $updateUri graphs: $graphs hashCode: $hashCode";
}

@Injectable()
class Endpoints extends EditableListItems<EditableEndpoint> {
  
  Endpoints():super(compareEndpoints);

  bool containsName(String name) => data.any((EditableEndpoint eq) => eq != selected && eq.model.name != null && eq.model.name.toLowerCase() == name.toLowerCase());
  EditableEndpoint findById(String id) => data.firstWhere((EditableEndpoint ee)=> ee.model.id == id, orElse:()=>null);
}

class EndpointSubPageModel extends SubPageEditableModel<Endpoint> {


  EndpointSubPageModel(PageEventBus bus, EndpointsService endpointService, Endpoints storage):super(bus, endpointService, storage, generate) {
    bus.on(ApplicationReady).listen((_) {
      loadAll(true);
    });
    
    bus.on(DatasetUploaded).listen((DatasetUploaded event) {
      EditableEndpoint endpoint = storage.findById(event.endpoint);
      refreshGraphs(endpoint);
    });
  }
  
  EndpointsService get endpointService => service;
  
  static EditableModel<Endpoint> generate([Endpoint item]) {
    if (item == null) return new EditableEndpoint(new Endpoint());
    
    //we are cloning
    if (item.id == null) item.bean[Endpoint.K.status]=Endpoint.K.status_data;
    return new EditableEndpoint(item);
  }
  
  void fireEndpointOperation() => bus.fireInPage(const EndpointOperation());
  void fireGraphOperation() => bus.fireInPage(const GraphOperation());

  void refreshGraphs(EditableEndpoint editableModel) {

    editableModel.loadingGraphs = true;
    Endpoint endpoint = editableModel.model;

    service.get(endpoint.name).then((Endpoint result) {
      endpoint.graphs = result.graphs;
    }).catchError((e) => onError(e, () => refreshGraphs(editableModel))).whenComplete(() {
      editableModel.loadingGraphs = false;
    });
  }

  void removeEndpointGraph(EditableEndpoint editableModel, Graph graph) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });

    endpointService.deleteEndpointGraph(editableModel.model, graph).then((bool result) {
      editableModel.model.graphs.remove(graph);
      fireGraphOperation();
    }).catchError((e) => onError(e, () => removeEndpointGraph(editableModel, graph))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });

  }

  void addEndpointGraph(EditableEndpoint editableModel, Graph graph) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });

    endpointService.addEndpointGraph(editableModel.model, graph).then((bool result) {
      editableModel.model.graphs.add(graph);
      fireGraphOperation();
    }).catchError((e) => onError(e, () => addEndpointGraph(editableModel, graph))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });
  }
  
  void editEndpointGraph(EditableEndpoint editableModel, Graph oldGraph, Graph newGraph) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });

    endpointService.editEndpointGraph(editableModel.model, newGraph).then((bool result) {
      oldGraph.label = newGraph.label;
      fireGraphOperation();
    }).catchError((e) => onError(e, () => editEndpointGraph(editableModel, oldGraph, newGraph))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });
  }
  
  void moveEndpointGraph(EditableEndpoint editableModel, Graph oldGraph, Graph newGraph, EditableEndpoint oldEndpoint, String newEndpointName) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });
    
    EditableEndpoint targetEndpoint = storage.findByName(newEndpointName);
    
    endpointService.moveEndpointGraph(targetEndpoint.model, oldGraph, newGraph, oldEndpoint.model.name).then((bool result) {
      refreshGraphs(targetEndpoint);
      refreshGraphs(oldEndpoint);
      fireGraphOperation();
    }).catchError((e) => onError(e, () => moveEndpointGraph(editableModel, oldGraph, newGraph, oldEndpoint, newEndpointName))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });
  }
  
  void saved(EditableEndpoint ee) {
    fireEndpointOperation();
  }
  
  void removed(EditableEndpoint ee) {
    fireEndpointOperation();
  }
  
}

class EditableEndpoint extends EditableModel<Endpoint> {

  @observable
  bool loadingGraphs = false;

  bool _dirty = false;

  EditableEndpoint(Endpoint endpoint) : super(endpoint) {

    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);

  }

  void _listenNewModel() {

    model.changes.listen((_) => _setDirty(true));

    onPropertyChange(this, #model, () => _setDirty(false));
  }

  void _setDirty(bool dirty) {
    _dirty = dirty;
    notifyPropertyChange(#dirty, null, _dirty);
  }

  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;

  String toString() => "EditableEndpoint model: $model";

}

class GradeEnpoints extends Observable with IterableMixin<EditableEndpoint> {

  @observable
  ObservableList<AreaEndpoints> areaEndpoints = new ObservableList();

  void addList(EndpointSubPageModel endpoints, String area) {
    areaEndpoints.add(new AreaEndpoints(endpoints.storage, endpoints.refreshGraphs, area));
  }

  EditableEndpoint findEditableEndpointById(String id) {
    for (AreaEndpoints areaEndpoints in areaEndpoints) {
      for (EditableEndpoint endpoint in areaEndpoints.endpointsStorage.synchedData) {
        if (endpoint.model.id == id) return endpoint;
      }
    }
    return null;
  }

  void refesh(String id) {
    for (AreaEndpoints areaEndpoints in areaEndpoints) {
      for (EditableEndpoint endpoint in areaEndpoints.endpointsStorage.synchedData) {
        if (endpoint.model.id == id) {
          areaEndpoints.refresh(endpoint);
          return;
        }
      }

    }
  }
  
  Iterator<EditableEndpoint> get iterator 
    => areaEndpoints
          .map((AreaEndpoints ae)=>ae.endpointsStorage.synchedData)
          .expand((List<EditableEndpoint> endpoints)=>endpoints).iterator;
}

typedef void Refresh(EditableEndpoint);

class AreaEndpoints {
  Endpoints endpointsStorage;
  Refresh refresh;
  String area;

  AreaEndpoints(this.endpointsStorage, this.refresh, this.area);
}

class DatasetUploaded {
  String endpoint;
  DatasetUploaded(this.endpoint);
}




