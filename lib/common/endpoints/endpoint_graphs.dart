part of endpoints;

@CustomTag("endpoint-graphs") 
class EndpointGraphs extends PolymerElement with Filters {
  
  GraphKeys K = new GraphKeys();
  
  int compareGraphs(Graph g1, Graph g2) {
    if (g1 == null || g1.label == null) return 1;
    if (g2 == null || g2.label == null) return -1;
    return compareIgnoreCase(g1.label, g2.label);
  }
  
  @published
  Endpoints items;
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  @observable
  bool newUrlInvalid = false;
  
  @observable
  String newUrl = "";
  
  @observable
  bool newLabelInvalid = false;
  
  @observable
  String newLabel = "";
  
  EndpointGraphs.created() : super.created();
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  void refreshGraphs() {
    fire("refresh-graphs", detail:item);
  }
  
  void addGraph() {
    fire("add-graph", detail:new Graph(newUrl, newLabel));
    newUrl = "";
    newLabel = "";
  }
  
  void removeGraph(event, detail, target) {
    fire("remove-graph", detail:target.attributes['graph']);
  }
}
