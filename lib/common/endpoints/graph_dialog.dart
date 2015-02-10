part of endpoints;

@CustomTag("graph-dialog")
class GraphDialog extends PolymerElement with Filters {

  GraphKeys K = new GraphKeys();

  @observable
  bool opened = false;

  @observable
  GraphDialogMode mode;
  
  Graph oldGraph;

  @observable
  String uri;

  @observable
  bool uriInvalid;

  @observable
  String label;

  @observable
  bool labelInvalid;

  @published
  Endpoints endpoints;
  
  @observable
  String endpointName;
  
  EditableEndpoint oldEndpoint;
  
  @observable
  bool endpointInvalid = false;

  GraphDialog.created() : super.created();

  @ComputedProperty("mode")
  String get dialogTitle {
    switch (mode) {
      case GraphDialogMode.ADD:
        return "Add graph";
      case GraphDialogMode.EDIT:
        return "Edit graph";
      case GraphDialogMode.MOVE:
        return "Move graph";
    }
    return "";
  }
  
  @ComputedProperty("mode")
  bool get canEditUri => mode != GraphDialogMode.EDIT;
  
  @ComputedProperty("mode")
  bool get requireEndpoint => mode == GraphDialogMode.MOVE;

  void openAdd() {
    reset();
    opened = true;
    mode = GraphDialogMode.ADD;
  }

  void openEdit(Graph graph) {
    oldGraph = graph;
    label = graph.label;
    uri = graph.uri;
    mode = GraphDialogMode.EDIT;
    opened = true;
  }

  void openMove(Graph graph, EditableEndpoint currentEndpoint) {
    oldGraph = graph;
    oldEndpoint = currentEndpoint;
    label = graph.label;
    uri = graph.uri + "-${new DateTime.now().millisecondsSinceEpoch}";
    mode = GraphDialogMode.MOVE;
    endpointName = endpoints.synchedData.any((EditableEndpoint e)=>e.model.id == currentEndpoint.model.id)?currentEndpoint.model.name:null;
    
    opened = true;
  }

  void reset() {
    label = null;
    uri = null;
  }

  void save() {
    switch (mode) {
      case GraphDialogMode.ADD: fire("added-graph", detail: new Graph(uri.trim(), label)); break;
      case GraphDialogMode.EDIT: fire("edited-graph", detail: {"old-graph":oldGraph, "new-graph":new Graph(uri.trim(), label)}); break;
      case GraphDialogMode.MOVE: fire("moved-graph", detail: {"old-graph":oldGraph, "new-graph":new Graph(uri.trim(), label), "old-endpoint":oldEndpoint, "new-endpoint-name":endpointName}); break;
    }
   
  }

  @ComputedProperty("labelInvalid || uriInvalid")
  bool get invalid => readValue(#invalid, () => false);

}

class GraphDialogMode {

  final String _value;
  const GraphDialogMode._internal(this._value);
  
  String toString() => "GraphDialogMode $_value";

  static const ADD = const GraphDialogMode._internal("ADD");
  static const EDIT = const GraphDialogMode._internal("EDIT");
  static const MOVE = const GraphDialogMode._internal("MOVE");
}
