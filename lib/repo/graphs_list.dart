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
    onPropertyChange(list, #data, selecteFirstItem);
  }
  
  void selecteFirstItem() {
    if (list.data != null && list.selection == null && list.data.isNotEmpty) {
      
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
