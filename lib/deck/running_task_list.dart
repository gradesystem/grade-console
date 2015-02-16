part of deck;

@CustomTag("running-task-list") 
class RunningTaskList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (RunningTask item, String term) 
                                =>  item.execution.task.label != null && 
                                    (item.execution.task.label.toLowerCase().contains(term.toLowerCase())
                                     || 
                                     item.execution.status.toLowerCase().contains(term.toLowerCase()));

  CoreResizable resizable;
  
  RunningTaskList.created() : super.created() {
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
