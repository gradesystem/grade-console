part of endpoints;

@CustomTag("graph-details-summary") 
class GraphDetailsSummary extends PolymerElement with Filters {
   
  @published
  Graph graph;
  
  GraphDetailsSummary.created() : super.created();
  
  void removeGraph() {
    fire("remove-graph", detail:graph);
  }
 
}
