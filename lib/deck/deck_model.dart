part of deck;

@Injectable()
class DeckPageModel {

  EventBus bus;

  TasksModel tasksModel;
  TaskExecutionsService executionsService;
  RunningTasks storage;

  DeckPageModel(this.bus, this.storage, this.tasksModel, this.executionsService) {
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
  }
  
  void cancelExecution(RunningTask runningTask) {
    //FIXME tasksModel.stopRunningTask(runningTask);
  }
  
  void removeExecution(RunningTask runningTask) {
    executionsService.delete(runningTask.execution);
    storage.data.remove(runningTask);
    
    //required for core-list issue https://github.com/dart-lang/core-elements/issues/160
    if (storage.data.isEmpty) storage.selected = null;
  }

  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    executionsService.getAll().then(_setData).catchError((e) => _onError(e, loadAll));

  }

  void _setData(List<TaskExecution> items) {

    storage.data.clear();
    storage.data.addAll(items.map(_toRunningTask));
    storage.loading = false;

  }
  
  RunningTask _toRunningTask(TaskExecution te) {
    RunningTask runningTask = new RunningTask.fromExecution(te);
    tasksModel.pollTaskExecution(runningTask);
    return runningTask;
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
    onPropertyChange(data, #lastChangedItem, _notifyRunningChanged);
    onPropertyChange(data, #length, _notifyRunningChanged);
  }
  
  void _notifyRunningChanged() {
    notifyPropertyChange(#running, null, running);
  }
  
  @observable
  List<RunningTask> get running => data.where((RunningTask e)=>e.running).toList();

}


