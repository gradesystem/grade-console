part of tasks;

@CustomTag("task-list")
class TaskList extends PolymerElement with Filters {

  @published
  String kfilter = '';
  
  ListFilter publishFilter = new ListFilter("PUBLISH", true);
  ListFilter addFilter = new ListFilter("ADD", true);
  ListFilter removeFilter = new ListFilter("REMOVE", true);
  
  @published
  ObservableList<ListFilter> filters = new ObservedItemList.from([]);

  @published
  ListItems listitems;

  CoreList list;

  bool clickflag = false;

  FilterFunction itemFilter = (EditableModel<Task> item, String term) 
      => Filters.containsIgnoreCase(item.model.label, term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.transform), term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.diff), term);
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
      
      return toObservable(items.where((EditableTask item) {
        return item.edit 
            || (publishFilter.active && item.model.operation == Operation.PUBLISH)
            || (addFilter.active && item.model.operation == Operation.ADD)
            || (removeFilter.active && item.model.operation == Operation.REMOVE);
      }).toList());
    };

  CoreResizable resizable;

  TaskList.created() : super.created() {
    resizable = new CoreResizable(this);
    filters.addAll([publishFilter, addFilter, removeFilter]);
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
    if (listitems.selected != null && listitems.selected != list.selection) {
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
