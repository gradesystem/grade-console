part of graphs;

@CustomTag("graph-item") 
class GraphItem extends PolymerElement with Filters {
  
  @published
  Graph graph;
  
  GraphItem.created() : super.created();
  
}