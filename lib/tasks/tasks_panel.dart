part of tasks;

@CustomTag("tasks-panel")
class TasksPanel extends PolymerElement with Filters {

  @observable
  int area = 0;

  @observable
  String kfilter = '';

  @published
  TasksModel model;

  @observable
  bool removeDialogOpened = false;

  @observable
  String removedDialogHeader;

  Function dialogCallback;

  TasksPanel.created() : super.created();

  Tasks get items => model.storage;

  void refresh() {
    model.loadAll();
  }

  void addTask() {
    model.addNew();
  }


  void cloneItem(event, detail, target) {
    model.clone(detail);
  }

  void removeItem(event, detail, target) {
    EditableTask deleteCandidate = detail;
    dialogCallback = () {
      model.remove(deleteCandidate);
    };
    Task task = deleteCandidate.model;
    removedDialogHeader = "Remove ${task.bean[Endpoint.K.name]}";
    removeDialogOpened = true;
  }


  void onEdit() {
    items.selected.startEdit();
  }

  void onCancel() {
    model.cancelEditing(items.selected);
  }

  void onSave() {
    model.save(items.selected);
  }

  void dialogAffermative() {
    if (dialogCallback != null) dialogCallback();
  }
   
  void onQueryPlayground() {
    area = 1;
  }
  
  void onBack() {
    area = 0;
  }
  
  void onRunTask(event, detail, target) {
    model.runSandboxTask(detail);
  }
  
  void onCancelTask(event, detail, target) {
    model.stopTask(detail);
  }
  

}
