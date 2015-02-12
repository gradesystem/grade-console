part of endpoints;

@CustomTag("endpoint-list") 
class EndpointList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  ListFilter dataFilter = new ListFilter("DATA", true);
  ListFilter lockedFilter = new ListFilter("LOCKED", true);
  ListFilter systemFilter = new ListFilter("SYSTEM", true);
  
  @published
  ObservableList<ListFilter> filters = new ObservedItemList.from([]);
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  bool clickflag = false;
  
  FilterFunction itemFilter = (EditableModel<Endpoint> item, String term) 
                    => item.model.name != null && 
                       item.model.name.toLowerCase().contains(term.toLowerCase());
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
      
      return toObservable(items.where((item) {
        return item.edit 
            || (dataFilter.active && !item.model.predefined)
            || (lockedFilter.active && item.model.locked)
            || (systemFilter.active && item.model.predefined);
      }).toList());
    };
  
  CoreResizable resizable;
  
  EndpointList.created() : super.created() {
    resizable = new CoreResizable(this);
    filters.addAll([dataFilter, lockedFilter, systemFilter]);
  }
  
  void attached() {
     super.attached();
     resizable.resizableAttachedHandler((_)=>list.updateSize());
   }
   
   void detached() {
     super.detached();
     resizable.resizableDetachedHandler();
   }
  
  void ready() {
    list = $['list'] as CoreList;
    //list.data.changes.listen((_){selecteFirstItem();});
    
    onPropertyChange(listitems, #selected, syncSelection);
    onPropertyChange(listitems.data, #isEmpty, (){
      async((_)=>list.updateSize());
    });
  }
  
  void syncSelection() {
    
    if (listitems.selected!= null && listitems.selected != list.selection) {
      if (listitems.selected == null) list.clearSelection();
      else {
        Map index = list.indexesForData(listitems.selected);
        if (index['virtual']>=0) list.selectItem(index['virtual']);
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
    if (!clickflag) listitems.selected = list.selection;
    else {
      syncSelection();
      clickflag = false;
    }
  }

  void setClickFlag() {
    clickflag = true;
  }
 
}
