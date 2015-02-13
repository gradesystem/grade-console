part of queries;

@CustomTag("query-list") 
class QueryList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  ListFilter servicesFilter = new ListFilter("SERVICES", true);
  ListFilter internalFilter = new ListFilter("INTERNAL", true);
  ListFilter systemFilter = new ListFilter("SYSTEM", false);
  
  @published
  ObservableList<ListFilter> filters = new ObservedItemList.from([]);
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  bool clickflag = false;
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => Filters.containsIgnoreCase(item.model.name, term)
                    || Filters.containsIgnoreCase(item.model.get(Query.K.expression), term)
                    || Filters.containsIgnoreCase(item.model.status, term);
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
    
    return toObservable(items.where((EditableQuery item) {
      return item.edit 
          || (servicesFilter.active && item.model.status == Query.K.status_service)
          || (internalFilter.active && (item.model.status == Query.K.status_internal && !item.model.isSystem))
          || (systemFilter.active && item.model.isSystem);
    }).toList());
  };
  
  CoreResizable resizable;
  
  QueryList.created() : super.created() {
    resizable = new CoreResizable(this);
    filters.addAll([servicesFilter, internalFilter, systemFilter]);
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
