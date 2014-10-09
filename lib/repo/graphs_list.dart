part of repo;

@CustomTag("graphs-list") 
class GraphsList extends Polybase {
  
  @published
  String searchTerm = '';
  CoreList list;
  
  FilterFunction itemFilter = (item, String term) => item.label.toLowerCase().contains(term.toLowerCase()) || item.note.toLowerCase().contains(term.toLowerCase());
  
  GraphsList.created() : super.createWith(Graphs);
  
  void ready() {
    list = $['list'] as CoreList;
    
    list.data.changes.listen((_){selecteFirstItem();});
  }
  
  void selecteFirstItem() {
    log.info("selecteFirstItem");
    if (list.data != null && list.data.isNotEmpty) {
      
      list.selectItem(0);
      //we are not notified about the selection
      graphs.selected = list.selection;
    }
  }
  
  void selectGraph(event) {
    graphs.selected = event.detail.data;
  }
  
  Graphs get graphs => model as Graphs;
 
}
