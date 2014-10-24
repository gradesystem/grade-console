part of queries;

@CustomTag("query-list") 
class QueryList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => item.model.get(Query.name_field) != null && 
                       item.model.get(Query.name_field).toLowerCase().contains(term.toLowerCase());
  
  QueryList.created() : super.created();
  
  void ready() {
    list = $['list'] as CoreList;
    list.data.changes.listen((_){selecteFirstItem();});
    
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
  
  void selecteFirstItem() {
    if (list.data != null && list.data.isNotEmpty && !list.data.contains(listitems.selected)) {
      
      list.selectItem(0);
      //we are not notified about the selection
      listitems.selected = list.selection;
    }
  }
  
  void selectDataset(event) {
    listitems.selected = event.detail.data;
  }
  
  void removeItem(event, detail, target) {
    listitems.data.remove(detail);
  }
 
}
