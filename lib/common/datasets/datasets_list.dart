part of datasets;

@CustomTag("datasets-list") 
class DatasetsList extends PolymerElement with Filters {
  
  @published
  String searchTerm = '';
  
  @published
  Datasets datasets;
  
  CoreList list;
  
  FilterFunction itemFilter = (item, String term) => item.label != null && item.label.toLowerCase().contains(term.toLowerCase());
  
  DatasetsList.created() : super.created();
  
  void ready() {
    list = $['list'] as CoreList;
    list.data.changes.listen((_){selecteFirstItem();});
  }
  
  void selecteFirstItem() {
    if (list.data != null && list.data.isNotEmpty) {
      
      list.selectItem(0);
      //we are not notified about the selection
      datasets.selected = list.selection;
    }
  }
  
  void selectDataset(event) {
    datasets.selected = event.detail.data;
  }
 
}
