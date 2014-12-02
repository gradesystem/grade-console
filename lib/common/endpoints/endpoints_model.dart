part of endpoints;

class EndpointKeys {

  const EndpointKeys();
  
  final String id = "http://gradesystem.io/onto#id";
  final String name = "http://gradesystem.io/onto/endpoint.owl#name";
  final String uri = "http://gradesystem.io/onto/endpoint.owl#uri";
  final String update_uri = "http://gradesystem.io/onto/endpoint.owl#update_uri";
  final String graphs = "http://gradesystem.io/onto/endpoint.owl#graph";
  final String predefined = "http://gradesystem.io/onto/endpoint.owl#predefined";
}

class Endpoint extends EditableGradeEntity with Filters {

  static EndpointKeys K = const EndpointKeys();

  ObservableList<String> _graphs = new ObservableList();
  
  Endpoint.fromBean(Map bean) : super(bean) {
    _syncGraphs();
    _listenChanges();
  }

  Endpoint() : this.fromBean({
        K.id: "",
        K.name: "",
        K.uri: "",
        K.update_uri: "",
        K.graphs: [],
        K.predefined: false
      });

  void _listenChanges() {
    onBeanChange([K.id], () => notifyPropertyChange(#id, null, id));
    onBeanChange([K.name], () => notifyPropertyChange(#name, null, name));
    onBeanChange([K.uri], () => notifyPropertyChange(#uri, null, uri));
    onBeanChange([K.update_uri], () => notifyPropertyChange(#updateUri, null, updateUri));
    //we don't support graphs direct writing
  }
  
  void _syncGraphs() {
    graphs = bean[K.graphs];
    bean[K.graphs] = graphs;
  }
  
  @observable
  get graphs => _graphs;
  set graphs(List<String> newgraphs) {
    graphs.clear();
    if (newgraphs!=null) graphs.addAll(newgraphs);
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

  bool get predefined => get(K.predefined);

  Endpoint clone() {
    return new Endpoint.fromBean(new Map.from(bean));
  }

  String toString() => "Endpoint id: $id name: $name uri: $uri updateUri: $updateUri graphs: $graphs hashCode: $hashCode";
}

abstract class Endpoints extends EditableListItems<EditableEndpoint> {

  bool containsName(String name) => data.any((EditableEndpoint eq) => eq != selected && eq.model.name != null && eq.model.name.toLowerCase() == name.toLowerCase());
  EditableEndpoint findById(String id) => data.firstWhere((EditableEndpoint ee)=> ee.model.id == id, orElse:()=>null);
}

abstract class EndpointSubPageModel extends SubPageEditableModel<Endpoint> {


  EndpointSubPageModel(EventBus bus, EndpointsService endpointService, Endpoints storage):super(bus, endpointService, storage, generate) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
  
  EndpointsService get endpointService => service;
  
  static EditableModel<Endpoint> generate([Endpoint item]) {
    if (item == null) return new EditableEndpoint(new Endpoint());
    
    //we are cloning
    if (item.id == null) item.bean[Endpoint.K.predefined]=false;
    return new EditableEndpoint(item);
  }

  void refreshGraphs(EditableEndpoint editableModel) {

    editableModel.loadingGraphs = true;
    Endpoint endpoint = editableModel.model;

    service.get(endpoint.name).then((Endpoint result) {
      endpoint.graphs = result.graphs;
    }).catchError((e) => onError(e, () => refreshGraphs(editableModel))).whenComplete(() {
      editableModel.loadingGraphs = false;
    });
  }

  void removeEndpointGraph(EditableEndpoint editableModel, String graph) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });

    endpointService.deleteEndpointGraph(editableModel.model, graph).then((bool result) {
      editableModel.model.graphs.remove(graph);
    }).catchError((e) => onError(e, () => removeEndpointGraph(editableModel, graph))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });

  }

  void addEndpointGraph(EditableEndpoint editableModel, String graph) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.loadingGraphs = true;
    });

    endpointService.addEndpointGraph(editableModel.model, graph).then((bool result) {
      editableModel.model.graphs.add(graph);
    }).catchError((e) => onError(e, () => addEndpointGraph(editableModel, graph))).whenComplete(() {
      timer.cancel();
      editableModel.loadingGraphs = false;
    });
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

class GradeEnpoints extends Observable {

  @observable
  ObservableList<AreaEndpoints> areaEndpoints = new ObservableList();

  void addList(Endpoints endpointsStorage, Refresh refresh, String area) {
    areaEndpoints.add(new AreaEndpoints(endpointsStorage, refresh, area));
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
}

typedef void Refresh(EditableEndpoint);

class AreaEndpoints {
  Endpoints endpointsStorage;
  Refresh refresh;
  String area;

  AreaEndpoints(this.endpointsStorage, this.refresh, this.area);
}
