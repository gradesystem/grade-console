part of repo;

@CustomTag("graphs-list") 
class GraphsList extends Polybase {
  
  @observable String searchTerm = '';
  
  FilterFunction itemFilter = (item, String term) => item.label.toLowerCase().contains(term.toLowerCase()) || item.note.toLowerCase().contains(term.toLowerCase());
  
  GraphsList.created() : super.createWith(Graphs);
  
  void selectGraph(event) {
    
    graphs.selected = event.detail.data;
  
  }
  
  Graphs get graphs => model as Graphs;
  
}
