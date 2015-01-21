part of tasks;

@CustomTag("tasks-panel")
class TasksPanel extends PolymerElement with Filters, Dependencies {

  @observable
  int area = 0;

  @observable
  String kfilter = '';

  @observable
  bool removeDialogOpened = false;

  @observable
  String removedDialogHeader;
  
  TasksModel model;

  Function dialogCallback;

  TasksPanel.created() : super.created(){
    model = instanceOf(TasksModel);
  }

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
  
  void onDescribeUri(event, detail, target) {
    String type = detail["type"];
    RunningTask runningTask = detail["runningTask"];
    Crumb crumb = detail["crumb"];
    _retrieveResult(type, runningTask, crumb);
  }
  
  void onLoadResult(event, detail, target) {
    String type = detail["type"];
    RunningTask runningTask = detail["runningTask"];
    _retrieveResult(type, runningTask);
  }
  
  void _retrieveResult(String type, RunningTask runningTask, [Crumb crumb]) {
    switch(type) {
      case "transform": model.retrieveTransformResult(runningTask, crumb); break;
      case "diff": model.retrieveDifferenceResult(runningTask, crumb); break;
      case "target": model.retrieveTargetResult(runningTask, crumb); break;
    }
  }

}
