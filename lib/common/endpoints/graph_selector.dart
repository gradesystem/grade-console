part of endpoints;

@CustomTag("graph-selector") 
class GraphSelector extends PolymerElement with Filters {
  
  @published
  EditableEndpoint endpoint;
  
  @published
  List<String> graphs;
  
  @observable
  List<String> invalidGraphUris = [];
  
  @published
  bool invalid;
  
  @published
  bool editable;
  
  @published
  bool required = false;
  
  @published
  bool multi = false;
  
  GraphSelector.created() : super.created();
  
  refreshEndpoint() {
    fire("refresh-endpoint", detail:endpoint);
  }
  
  //workaround to observeproperty not listening to target.model.graphs
  @ComputedProperty("endpoint.model.graphs")
  List<Graph> get endpointGraphs => endpoint!=null?endpoint.model.graphs:[];
  
  @ObserveProperty("graphs endpointGraphs")
  void calculateInvalidGraphUris() {
    invalidGraphUris = graphs!=null?graphs.where((uri)=>!endpointGraphs.any((Graph g)=>g.uri == uri)).toList():[];
    if (graphs!=null) invalid = invalidGraphUris.isNotEmpty || (graphs.isEmpty && required);
  } 
  
  @ComputedProperty("invalid")
  String get invalidMessage => invalidGraphUris.isNotEmpty?"Some graph are no longer a valid choice, pick another.":"Please make a choice.";
}
