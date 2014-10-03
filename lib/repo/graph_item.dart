part of repo;


@CustomTag("graph-item") 
class GraphItem extends PolymerElement {
  
  @published
  Graph graph;
  
  GraphItem.created() : super.created();
  
  lowercase(String s) => s.toLowerCase();
  
}