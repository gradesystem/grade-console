part of repo;

@CustomTag("graphs-list") 
class GraphsList extends Polybase {
  
  GraphsList.created() : super.createWith(Graphs);
  
  void selectGraph(event) {
    
    graphs.selected = event.detail.data;
  
  }
  
  Graphs get graphs => model as Graphs;
  
}