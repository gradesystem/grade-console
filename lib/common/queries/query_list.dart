part of queries;

@CustomTag("query-list") 
class QueryList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  bool clickflag = false;
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => item.model.name != null && 
                       item.model.name.toLowerCase().contains(term.toLowerCase());
  
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
  
  void selectItem(event) {
    //workaround to https://github.com/dart-lang/core-elements/issues/160
    if (!clickflag) listitems.selected = event.detail.data;
    else {
      syncSelection();
      clickflag = false;
    }
  }

  void setClickFlag() {
    clickflag = true;
  }
 
}
