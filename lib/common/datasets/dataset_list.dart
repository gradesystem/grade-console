part of datasets;

@CustomTag("dataset-list") 
class DatasetList extends ResizerPolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (Dataset item, String term) => item.title != null && item.title.toLowerCase().contains(term.toLowerCase());
  
  DatasetList.created() : super.created() {
    addEventListener("core-resize", (_){print('core-resize DatasetList');});
    
    addEventListener("core-resize", (_)=>list.updateSize());
  }
  
  void ready() {
    list = $['list'] as CoreList;
    
    onPropertyChange(listitems, #selected, syncSelection);
  }
  
  void syncSelection() {
    if (listitems.selected!= null && listitems.selected != list.selection) {
      if (listitems.selected == null) list.clearSelection();
      else {
        int index = listitems.data.indexOf(listitems.selected);
        list.selectItem(index);
      }
    }
  } 
  
  void selectDataset(event) {
    listitems.selected = event.detail.data;
  }
 
}
