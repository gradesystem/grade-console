part of tasks;

@CustomTag("task-list")
class TaskList extends PolymerElement with Filters {

  @published
  String kfilter = '';

  @published
  ListItems listitems;

  CoreList list;

  bool clickflag = false;

  FilterFunction itemFilter = (EditableModel<Task> item, String term) 
      => Filters.containsIgnoreCase(item.model.label, term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.transform), term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.diff), term);

  CoreResizable resizable;

  TaskList.created() : super.created() {
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
    if (listitems.selected != null && listitems.selected != list.selection) {
      if (listitems.selected == null) list.clearSelection(); 
      else {
        int index = listitems.data.indexOf(listitems.selected);
        list.selectItem(index);
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
