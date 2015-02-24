part of endpoints;

@CustomTag("graph-dialog")
class GraphDialog extends PolymerElement with Filters {
  
  static String ERROR_MESSAGE = "Not original enough, try again.";

  GraphKeys K = new GraphKeys();

  @observable
  bool opened = false;

  @observable
  GraphDialogMode mode;
  
  Graph oldGraph;

  @observable
  String uri;
  
  bool uriModifiedByUser = false;

  @observable
  bool uriInvalid;

  @observable
  String label;

  @observable
  bool labelInvalid;
  
  @published
  Endpoints endpoints;
  
  @published
  EditableEndpoint currentEndpoint;
  
  @observable
  String endpointName;
  
  @observable
  EditableEndpoint oldEndpoint;
  
  @observable
  bool endpointInvalid = false;
  
  @observable
  bool deleteOriginal;
  
  GradeInput labelInput;

  GraphDialog.created() : super.created();
  
  void ready() {
    (($["uriInput"] as Element).shadowRoot.querySelector("input") as InputElement).onKeyPress.listen((_){
      uriModifiedByUser = true;
    });
    labelInput = $["labelInput"];
  }

  @ComputedProperty("mode")
  String get dialogTitle {
    switch (mode) {
      case GraphDialogMode.ADD:
        return "Add graph";
      case GraphDialogMode.EDIT:
        return "Edit graph";
      case GraphDialogMode.MOVE:
        return "Copy/Move graph";
    }
    return "";
  }
  
  @ComputedProperty("mode")
  bool get canEditUri => mode != GraphDialogMode.EDIT;
  
  @ComputedProperty("mode")
  bool get isMove => mode == GraphDialogMode.MOVE;
  
  @ComputedProperty("isMove && oldEndpoint.model.writable")
  bool get canMove => readValue(#canMove, ()=>false);
  
  List<EditableEndpoint> writable(List<EditableEndpoint> endpoints) => endpoints.where((EditableEndpoint ee)=>ee.model.writable).toList();

  void openAdd() {
    reset();
    uri = calculateAddUri();
    opened = true;
    mode = GraphDialogMode.ADD;
  }

  void openEdit(Graph graph) {
    reset();
    oldGraph = graph;
    label = graph.label;
    uri = graph.uri;
    mode = GraphDialogMode.EDIT;
    opened = true;
  }

  void openMove(Graph graph, EditableEndpoint currentEndpoint) {
    
    reset();
    oldGraph = graph;
    oldEndpoint = currentEndpoint;
    label = graph.label;
    mode = GraphDialogMode.MOVE;
    deleteOriginal = false;
    
    uriModifiedByUser = false;
    
    endpointName = endpoints.synchedData.any((EditableEndpoint e)=>e.model.writable && e.model.id == currentEndpoint.model.id)?currentEndpoint.model.name:null;
    calculateUri();

    opened = true;
  }
  
  @ObserveProperty("endpointName")
  void calculateUri() {
    if (mode == GraphDialogMode.MOVE && !uriModifiedByUser) {
      uriInvalid = false;
      uri = calculateMoveUri(oldGraph.uri);
    }
  }
  
  @ObserveProperty("label endpointName")
  void calculateLabelError() {
    if (endpointName == null || label == null) return;
    
    EditableEndpoint targetEndpoint = endpoints.findByName(endpointName);
    if (targetEndpoint.model.graphs.any((Graph graph)=>graph.label == label)) labelInput.error = ERROR_MESSAGE;
    else if (labelInput.error == ERROR_MESSAGE) labelInput.error = "";
  }

  void reset() {
    label = null;
    uri = null;
  }

  void save() {
    switch (mode) {
      case GraphDialogMode.ADD: fire("added-graph", detail: new Graph(uri.trim(), label)); break;
      case GraphDialogMode.EDIT: fire("edited-graph", detail: {"old-graph":oldGraph, "new-graph":new Graph(uri.trim(), label)}); break;
      case GraphDialogMode.MOVE: fire("moved-graph", detail: {"old-graph":oldGraph, "new-graph":new Graph(uri.trim(), label), "old-endpoint":oldEndpoint, "new-endpoint-name":endpointName, "delete-original":deleteOriginal}); break;
    }
   
  }

  @ComputedProperty("labelInvalid || uriInvalid || (isMove && endpointInvalid)")
  bool get invalid => readValue(#invalid, () => false);
  
  String calculateMoveUri(String current) {

    if (endpointName == null) return current;
    
    String local = getLocal(current);
    
    if (endpointName == currentEndpoint.model.name) return "${getPrefixLocal(current)}/<version>/$local";
    
    EditableEndpoint targetEndpoint = endpoints.findByName(endpointName);
    
    if (targetEndpoint.model.graphs.isEmpty) return "${endpointDefaultUri(targetEndpoint)}/$local";
    String prefix = endpointPrefix(targetEndpoint);
    return "$prefix$local";
  }
  
  String getLocal(String uri) {
    int slashIndex = uri.lastIndexOf("/");
    if (slashIndex>=0 && slashIndex<uri.length) return uri.substring(slashIndex+1);
    return uri;
  }
  
  String getPrefixLocal(String uri) {
    int slashIndex = uri.lastIndexOf("/");
    if (slashIndex>=0 && slashIndex<uri.length) return uri.substring(0,slashIndex);
    return uri;
  }
  
  String calculateAddUri() {
    if (currentEndpoint.model.graphs.isEmpty) return endpointDefaultUri(currentEndpoint);
    return endpointPrefix(currentEndpoint);
  }
  
  String endpointPrefix(EditableEndpoint endpoint)  {
    List<String> uris = endpoint.model.graphs.map((Graph graph)=>graph.uri.toLowerCase()).toList();
    
    String prefix = "";
    
    if (uris.length == 1) {
      //if there is only one graph in the endpoint, we remove the local part from the uri in order to obtain the prefix
      prefix = uris.first;
      int slashIndex = prefix.lastIndexOf("/");
      if (slashIndex>=0) prefix = prefix.substring(0, slashIndex);
    } else prefix = longestCommonPrefix(uris);
    
    if (!prefix.endsWith("/")) prefix = prefix + "/";
    return prefix;
  }
  
  String endpointDefaultUri(EditableEndpoint endpoint) => "http://data.gradesystem.eu/graphs/${endpoint.model.name}"; 
  
  String longestCommonPrefix(List<String> strings) {
      if (strings.isEmpty) return "";

      String candidate = strings[0];
      for (int prefixLen = 0; prefixLen < candidate.length; prefixLen++) {
          int c = candidate.codeUnitAt(prefixLen);
          for (int i = 1; i < strings.length; i++) {
              if (prefixLen >= strings[i].length 
                  || strings[i].codeUnitAt(prefixLen) != c) {
                  return strings[i].substring(0, prefixLen);
              }
          }
      }
      return candidate;
  }

}

class GraphDialogMode {

  final String _value;
  const GraphDialogMode._internal(this._value);
  
  String toString() => "GraphDialogMode $_value";

  static const ADD = const GraphDialogMode._internal("ADD");
  static const EDIT = const GraphDialogMode._internal("EDIT");
  static const MOVE = const GraphDialogMode._internal("MOVE");
}
