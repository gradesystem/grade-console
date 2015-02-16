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
    
    listitems.selection.listen(syncSelected);
    
    onPropertyChange(list, #selection, (){listitems.selected = list.selection;});
    
    onPropertyChange(listitems.data, #isEmpty, (){
      async((_)=>list.updateSize());
    });
  }

  
  void syncSelected(SelectionChange change) {
    async((_) {
      var selected = change.selectFirst && list.data.isNotEmpty?list.data.first:change.item;
      if (selected != list.selection) {
        if (selected == null) list.clearSelection();
        else {
          Map index = list.indexesForData(selected);
          if (index['virtual']>=0) list.selectItem(index['virtual']);
        }
      }
    });
  }

}
