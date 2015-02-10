part of queries;

@CustomTag("query-list") 
class QueryList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ObservableList<ListFilter> filters = new ObservedItemList.from([
                               new ListFilter("SERVICES", true, (EditableModel<Query> item)=>item.model.status == Query.K.status_service),
                               new ListFilter("INTERNAL", true, (EditableModel<Query> item)=>item.model.status == Query.K.status_internal),
                               new ListFilter("PREDEFINED", false, (EditableModel<Query> item)=>item.model.predefined)
                               ]);
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  bool clickflag = false;
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => Filters.containsIgnoreCase(item.model.name, term)
                    || Filters.containsIgnoreCase(item.model.get(Query.K.expression), term)
                    || Filters.containsIgnoreCase(item.model.status, term);
  
  applyFilters(List<ListFilter> filters, _) => (List items) => toObservable(items.where((EditableModel<Query> item) => filters.any((filter)=>filter.active && filter.filter(item))).toList());
  
  CoreResizable resizable;
  
  QueryList.created() : super.created() {
    resizable = new CoreResizable(this);
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
