part of endpoints;

@CustomTag("graph-details-summary") 
class GraphDetailsSummary extends PolymerElement with Filters {
   
  @published
  Graph graph;
  
  @published
  bool removeEnabled;
  
  GraphDetailsSummary.created() : super.created();
  
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
