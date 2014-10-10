part of graphs;

@CustomTag("graphs-list") 
class GraphsList extends PolymerElement with Filters {
  
  @published
  String searchTerm = '';
  
  @published
  Graphs graphs;
  
  CoreList list;
  
  FilterFunction itemFilter = (item, String term) => item.label.toLowerCase().contains(term.toLowerCase()) || item.note.toLowerCase().contains(term.toLowerCase());
  
  GraphsList.created() : super.created();
  
  void ready() {
    list = $['list'] as CoreList;
    list.data.changes.listen((_){selecteFirstItem();});
  }
  
  void selecteFirstItem() {
    if (list.data != null && list.data.isNotEmpty) {
      
      list.selectItem(0);
      //we are not notified about the selection
      graphs.selected = list.selection;
    }
  }
  
  void selectGraph(event) {
    graphs.selected = event.detail.data;
  }
 
}
