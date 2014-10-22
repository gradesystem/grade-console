part of tasks;

@CustomTag("tasks-panel") 
class TasksPanel extends PolymerElement with Filters {
  
  @observable
  String kfilter='';
  
  @published
  SubPageModel<Task> model;
  
  @published
  bool edit = false;
  
  TasksPanel.created() : super.created();
  
  Tasks get tasks => model.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void onEdit() {
    log.info("onEdit");
    edit = true;
  }
  
  void onCancel() {
    log.info("onCancel");
    edit = false;
  }
  
  void onSave() {
    log.info("onSave");
    edit = false;
  }
 
}
