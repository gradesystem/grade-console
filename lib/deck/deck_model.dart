part of deck;

@Injectable()
class DeckPageModel {

  PageEventBus bus;

  TasksModel tasksModel;
  TaskExecutionsService executionsService;
  RunningTasks storage;

  DeckPageModel(@DeckAnnotation() this.bus, this.storage, this.tasksModel, this.executionsService) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
  
  Tasks get tasks => tasksModel.storage;
  void refreshTasks() {
    tasksModel.loadAll();
  }
  
  void runTask(EditableTask editableTask) {
    RunningTask runningTask = tasksModel.runTask(editableTask);
    storage.data.add(runningTask);
    storage.select(runningTask);
  }
  
  void cancelExecution(RunningTask runningTask) {
    tasksModel.stopRunningTask(runningTask);
  }
  
  void removeExecution(RunningTask runningTask) {
    executionsService.delete(runningTask.execution);
    storage.data.remove(runningTask);
    
    //required for core-list issue https://github.com/dart-lang/core-elements/issues/160
    if (storage.data.isEmpty) storage.clearSelection();
  }
  
  void loadRunnable() {
    tasksModel.loadAll();
  }
  
  void removeAllExecuted() {
    storage.loading = true;
    List<RunningTask> toDelete = storage.data.where((RunningTask rt)=>!rt.running).toList();
    toDelete.forEach(removeExecution);
    storage.loading = false;
  }

  void loadAll() {
    storage.loading = true;
    storage.clearSelection();
    executionsService.getAll().then(_setData).catchError((e) => _onError(e, loadAll));
  }

  void _setData(List<TaskExecution> items) {

    _clear();
    storage.data.addAll(items.map(_toRunningTask));
    storage.selectFirst();
    storage.loading = false;

  }
  
  void _clear() {
    storage.data.forEach((RunningTask rt){
      if (rt.running) rt.stopPolling();
    });
    storage.data.clear();
  }
  
  RunningTask _toRunningTask(TaskExecution te) {
    RunningTask runningTask = new RunningTask.fromExecution(te);
    tasksModel.updateTaskExecution(runningTask, te);
    tasksModel.listenTaskExecution(runningTask);
    return runningTask;
  }
  
  void retrieveTransformResult(RunningTask runningTask, [Crumb crumb]) {
    tasksModel.retrieveTransformResult(runningTask, crumb);
  }
  
  void retrieveDifferenceResult(RunningTask runningTask, [Crumb crumb]) {
    tasksModel.retrieveDifferenceResult(runningTask, crumb);
  }
  
  void retrieveTargetResult(RunningTask runningTask, [Crumb crumb]) {
    tasksModel.retrieveTargetResult(runningTask, crumb);
  }


  void _onError(e, callback) {
    storage.data.clear();
    storage.loading = false;
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}

@Injectable()
class RunningTasks extends ListItems<RunningTask> {
  
  RunningTasks() {
    onPropertyChange(data, #lastChangedItem, _notifyDerivedChanged);
    onPropertyChange(data, #length, _notifyDerivedChanged);
  }
  
  void _notifyDerivedChanged() {
    notifyPropertyChange(#running, null, running);
    notifyPropertyChange(#failed, null, failed);
  }
  
  @observable
  List<RunningTask> get running => data.where((RunningTask e)=>e.running).toList();
  
  @observable
  List<RunningTask> get failed => data.where((RunningTask e)=>e.execution!=null && e.execution.failed).toList();
    

}