part of endpoints;

@CustomTag("graph-details-summary") 
class GraphDetailsSummary extends PolymerElement with Filters {
   
  @published
  Graph graph;
  
  @published
  bool removeEnabled;
  
  GraphDetailsSummary.created() : super.created();
  
  @ComputedProperty("graph.size")
  String get size => graph.size!=null ? graph.size>0?"(${graph.size}T)":"(empty)":"n/a";
  
  void editGraph() {
    fire("edit-graph", detail:graph);
  }

  void moveGraph() {
    fire("move-graph", detail:graph);
  }
  
  void removeGraph() {
    fire("remove-graph", detail:graph);
  }
 
}
