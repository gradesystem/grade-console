part of datasets;

@CustomTag("dataset-list") 
class DatasetList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (ListItem item, String term) => item.title != null && item.title.toLowerCase().contains(term.toLowerCase());
  
  DatasetList.created() : super.created();
  
  void ready() {
    list = $['list'] as CoreList;
    list.data.changes.listen((_){selecteFirstItem();});
  }
  
  void selecteFirstItem() {
    if (list.data != null && list.data.isNotEmpty) {
      
      list.selectItem(0);
      //we are not notified about the selection
      listitems.selected = list.selection;
    }
  }
  
  void selectDataset(event) {
    listitems.selected = event.detail.data;
  }
 
}