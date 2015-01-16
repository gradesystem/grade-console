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

  TaskList.created() : super.created();

  void ready() {
    list = $['list'] as CoreList;

    onPropertyChange(listitems, #selected, syncSelection);
  }

  void syncSelection() {
    if (listitems.selected != null && listitems.selected != list.selection) {
      if (listitems.selected == null) list.clearSelection(); else {
        int index = listitems.data.indexOf(listitems.selected);
        list.selectItem(index);
      }
    }
  }

  void selectItem(event) {
    //workaround to https://github.com/dart-lang/core-elements/issues/160
    if (!clickflag) listitems.selected = event.detail.data; else {
      syncSelection();
      clickflag = false;
    }
  }

  void setClickFlag() {
    clickflag = true;
  }

}
