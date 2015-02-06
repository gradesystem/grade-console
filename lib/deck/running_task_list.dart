part of deck;

@CustomTag("running-task-list") 
class RunningTaskList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  bool clickflag = false;
  
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
    list.data.changes.listen((_){selecteFirstItem();});
    
    onPropertyChange(listitems, #selected, syncSelection);
    onPropertyChange(listitems.data, #isEmpty, (){
      async((_)=>list.updateSize());
    });
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
