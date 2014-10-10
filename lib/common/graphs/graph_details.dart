part of graphs;

@CustomTag("graph-details") 
class GraphDetails extends PolymerElement with Filters {
  
  @published
  Graph graph;
  
  GraphDetails.created() : super.created();
  
}