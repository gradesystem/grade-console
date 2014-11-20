part of endpoints;

class Endpoint extends EditableGradeEntity with Filters {

  static String id_field = "http://gradesystem.io/onto#id";
  static String name_field = "http://gradesystem.io/onto/endpoint.owl#name";
  static String uri_field = "http://gradesystem.io/onto/endpoint.owl#uri";
  static String update_uri_field = "http://gradesystem.io/onto/endpoint.owl#update_uri";
  static String graphs_field = "http://gradesystem.io/onto/endpoint.owl#graph";
  static String predefined_field = "http://gradesystem.io/onto/endpoint.owl#predefined";

  Endpoint.fromBean(Map bean) : super(bean) {

    _listenChanges();
  }

  Endpoint() : this.fromBean({
        id_field: "",
        name_field: "",
        uri_field: "",
        update_uri_field: "",
        predefined_field: false
      });

  void _listenChanges() {
    onBeanChange([id_field], () => notifyPropertyChange(#id, null, id));
    onBeanChange([name_field], () => notifyPropertyChange(#name, null, name));
    onBeanChange([uri_field], () => notifyPropertyChange(#uri, null, uri));
    onBeanChange([update_uri_field], () => notifyPropertyChange(#updateUri, null, updateUri));
    onBeanChange([graphs_field], () => notifyPropertyChange(#graphs, null, graphs));
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

  bool containsName(String name) => data.any((EditableEndpoint eq) => eq != selected && eq.model.name != null && eq.model.name.toLowerCase() == name.toLowerCase());
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
    if (item.id == null) item.bean[Endpoint.predefined_field]=false;
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

  EditableEndpoint findEditableEndpointByUri(String uri) {
    for (AreaEndpoints areaEndpoints in areaEndpoints) {
      for (EditableEndpoint endpoint in areaEndpoints.endpointsStorage.synchedData) {
        if (endpoint.model.uri == uri) return endpoint;
      }
    }
    return null;
  }

  void refesh(String uri) {
    for (AreaEndpoints areaEndpoints in areaEndpoints) {
      for (EditableEndpoint endpoint in areaEndpoints.endpointsStorage.synchedData) {
        if (endpoint.model.uri == uri) {
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
