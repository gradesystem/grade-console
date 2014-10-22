part of tasks;

@CustomTag("tasks-panel") 
class TasksPanel extends PolymerElement with Filters {
  
  @observable
  String kfilter='';
  
  @published
  SubPageModel<Task> model;
  
  @published
  bool editable = false;
  
  TasksPanel.created() : super.created();
  
  Tasks get tasks => model.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void onEdit() {
    editable = !editable;
  }
 
}
