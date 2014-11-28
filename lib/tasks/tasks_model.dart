part of tasks;

class TaskKeys {

  const TaskKeys();

  final String uri = "http://gradesystem.io/onto#uri";
  final String label = "http://www.w3.org/2000/01/rdf-schema#label";

  final String op = "http://gradesystem.io/onto/task.owl#operation";
  final String publish_op = 'http://gradesystem.io/onto/task.owl#publish';
  final String add_op = 'http://gradesystem.io/onto/task.owl#add';
  final String remove_op = 'http://gradesystem.io/onto/task.owl#remove';

  final String source_endpoint = "http://gradesystem.io/onto/task.owl#source_endpoint";
  final String source_graph = "http://gradesystem.io/onto/task.owl#source_graph";

  final String target_endpoint = "http://gradesystem.io/onto/task.owl#target_endpoint";
  final String target_graph = "http://gradesystem.io/onto/task.owl#target_graph";

  final String transform = "http://gradesystem.io/onto/task.owl#transform";
  final String diff = "http://gradesystem.io/onto/task.owl#difference";

  final String note = "http://www.w3.org/2004/02/skos/core#editorialNote";
  final String creator = "http://purl.org/dc/terms/creator";

}

class Task extends EditableGradeEntity with Filters {

  static TaskKeys K = const TaskKeys();

  Task.fromBean(Map bean) : super(bean) {
    onBeanChange([K.label], () => notifyPropertyChange(#label, null, label));
    onBeanChange([K.uri], () => notifyPropertyChange(#name, null, name));
    onBeanChange([K.op], () => notifyPropertyChange(#operation, null, operation));
  }

  Task() : this.fromBean({
    K.op:K.publish_op
    
  });

  String get id => get(K.uri);
  set id(String value) => set(K.uri, value);

  @observable
  String get name => get(K.uri);
  set name(String value) {
    set(K.uri, value);
    notifyPropertyChange(#name, null, value);
  }

  String get label => get(K.label);

  Operation get operation => Operation.parse(get(K.op));
  set operation(Operation operation) {

    set(K.op, operation != null ? operation.value : null);
    notifyPropertyChange(#operation, null, operation);
  }

  Task clone() {
    return new Task.fromBean(new Map.from(bean));
  }
}

class EditableTask extends EditableModel<Task> with Keyed {

  static TaskKeys K = const TaskKeys();
  
  @observable
  RunningTask playgroundRunningTask;

  bool _dirty = false;

  EditableTask(Task task) : super(task) {
    
    playgroundRunningTask = new RunningTask(model);

    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);

    //when task is edited we reset the last error
    //FIXME onPropertyChange(this, #dirty, resetLastError);
  }

  get(key) => model.get(key);
  set(key, value) => model.set(key, value);

  bool calculateFieldsValidity() => fieldsInvalidity.keys//we skip the diff query if the operation is publish
  .where((String field) => !(field == K.diff && get(K.op) == K.publish_op)).map((String field) => fieldsInvalidity[field])//we are watching invalidity
  .every((b) => !b);

  void _listenNewModel() {

    model.changes.listen((_) => _setDirty(true));

    onPropertyChange(this, #model, () => _setDirty(false));

    //we need to update validity after operation change
    model.onBeanChange([K.op], updateValidity);
  }

  void _setDirty(bool dirty) {
    _dirty = dirty;
    notifyPropertyChange(#dirty, null, _dirty);
  }

  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;

}

class Operation {

  static UnmodifiableListView<Operation> values = new UnmodifiableListView([PUBLISH, ADD, REMOVE]);

  static Operation parse(String value) => values.firstWhere((Operation o) => o._value == value, orElse: () => null);

  final _value;
  final _label;
  const Operation._internal(this._value, this._label);
  toString() => 'Operation.$_value';

  String get value => _value;
  String get label => _label;

  static const PUBLISH = const Operation._internal('http://gradesystem.io/onto/task.owl#publish', 'publish');
  static const ADD = const Operation._internal('http://gradesystem.io/onto/task.owl#add', 'add');
  static const REMOVE = const Operation._internal('http://gradesystem.io/onto/task.owl#remove', 'remove');
}


@Injectable()
class TasksPageModel {

  TasksModel tasksModel;
  TasksQueriesModel queriesModel;
  TasksEndpointsModel endpointsModel;

  TasksPageModel(this.tasksModel, this.queriesModel, this.endpointsModel);
}


@Injectable()
class TasksModel extends SubPageEditableModel<Task> {
  
  static Duration EXECUTION_POLL_DELAY = new Duration(seconds:1);
  
  static TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  TaskExecutionsService executionsService; 

  TasksModel(EventBus bus, TasksService service, this.executionsService, Tasks storage) : super(bus, service, storage, generate) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }

  TasksService get taskService => service;

  static EditableTask generate([Task item]) {
    if (item == null) return new EditableTask(new Task());
    return new EditableTask(item);
  }
  
  RunningTask runTask(EditableTask editableTask) {
    RunningTask runningTask = new RunningTask(editableTask.model); 
    _run(runningTask, editableTask.model, taskService.runTask);
    return runningTask;
  }

  void runSandboxTask(EditableTask editableTask) {
    if (editableTask.playgroundRunningTask.execution!=null) executionsService.stopTaskExecution(editableTask.playgroundRunningTask.execution);
    _run(editableTask.playgroundRunningTask, editableTask.model, taskService.runSandboxTask);
  }
  
  
  void _run(RunningTask runningTask, Task task, Future<TaskExecution> runner(Task)) {
    runningTask.runTask();
    runner(task)
      .then((TaskExecution update) {
          updateTaskExecution(runningTask, update);
          _listenTaskExecution(runningTask);
        })
      .catchError((e) => runningTask.taskFailed(e));
  }
  
  void stopTask(EditableTask editableTask) {
    stopRunningTask(editableTask.playgroundRunningTask);
  }
  
  void stopRunningTask(RunningTask runningTask) {
    if (!runningTask.canCancel || !runningTask.running) return;
    runningTask.stopTask();
    executionsService.stopTaskExecution(runningTask.execution);
  }
  
  void _listenTaskExecution(RunningTask editableTask) {
    //the user can stop the task during the first ajax call
    if (editableTask.running) 
      editableTask.executionPoller = new Timer.periodic(EXECUTION_POLL_DELAY, (_)=>pollTaskExecution(editableTask));
  }
  
  void pollTaskExecution(RunningTask runningTask) {
    if (!runningTask.running) return;
    
    executionsService.pollTaskExecution(runningTask.execution)
    .then((TaskExecution update) => updateTaskExecution(runningTask, update))
    .catchError((e) {
      runningTask.taskFailed(e);
      onError(e, null);
    });
  }
  
  void updateTaskExecution(RunningTask runningTask, TaskExecution execution) {
    runningTask.executionUpdate(execution);
    if (execution.transformed && !runningTask.transform.hasValue) retrieveTransformResult(runningTask);
    if (execution.difference && execution.differenceOperation && !runningTask.diff.hasValue) retrieveDifferenceResult(runningTask);
    if (execution.completed) retrieveTargetResult(runningTask);
  }
  
  void retrieveTargetResult(RunningTask runningTask)
    => retrieveResult(runningTask, executionsService.getTargetResult, runningTask.target);
  
  void retrieveDifferenceResult(RunningTask runningTask)
    => retrieveResult(runningTask, executionsService.getDifferenceResult, runningTask.diff);

  void retrieveTransformResult(RunningTask runningTask)
    => retrieveResult(runningTask, executionsService.getTransformResult, runningTask.transform);
  
  void retrieveResult(RunningTask runningTask, Future<QueryResult> retriever(RunningTask), Result result) {
    result.loading = true;
    retriever(runningTask.execution)
    .then((QueryResult resultQuery){
      result.value = resultQuery;
    }).catchError((e) => onError(e, null)).whenComplete(() {
      result.loading = false;
    });
  }

}

class TaskExecutionLists {
  
  static TaskExecutionKeys K = const TaskExecutionKeys();

  static final List<String> statuses = [K.status_submitted,K.status_started,K.status_transformed,K.status_modified,K.status_completed];
  static final List<String> phases = [K.phase_startup,K.phase_transformation,K.phase_difference,K.phase_writeout];
  
}

class TaskExecutionKeys {

 final String id = "http://gradesystem.io/onto#id";

  final String startTime =  "http://gradesystem.io/onto/taskexecution.owl#startTime";
  final String endTime = "http://gradesystem.io/onto/taskexecution.owl#endTime";
  
  final String task = "http://gradesystem.io/onto/task.owl#Task";

  final String status = "http://gradesystem.io/onto/taskexecution.owl#status";
  
  final String status_submitted = "http://gradesystem.io/onto/taskexecution.owl#submitted";
  final String status_started = "http://gradesystem.io/onto/taskexecution.owl#started";
  final String status_transformed = "http://gradesystem.io/onto/taskexecution.owl#transformed";
  final String status_modified = "http://gradesystem.io/onto/taskexecution.owl#modified";
  final String status_failed =  "http://gradesystem.io/onto/taskexecution.owl#failed";
  final String status_completed =  "http://gradesystem.io/onto/taskexecution.owl#completed";

  const TaskExecutionKeys();
   
    
  final String phase = "http://gradesystem.io/onto/taskexecution.owl#phase";
  
  final String phase_startup = "http://gradesystem.io/onto/taskexecution.owl#startup";
  final String phase_transformation = "http://gradesystem.io/onto/taskexecution.owl#transformation";
  final String phase_difference = "http://gradesystem.io/onto/taskexecution.owl#difference";
  final String phase_writeout = "http://gradesystem.io/onto/taskexecution.owl#writeout";
  
  final String source = "http://gradesystem.io/onto/taskexecution.owl#source";
  final String target = "http://gradesystem.io/onto/taskexecution.owl#target";
  
  final String error = "http://gradesystem.io/onto/taskexecution.owl#error";
  final String log = "http://gradesystem.io/onto/taskexecution.owl#log";
  final String duration = "http://gradesystem.io/onto/taskexecution.owl#duration";
 
}

class TaskExecution extends GradeEntity {

  static TaskExecutionKeys K = const TaskExecutionKeys();
  
  static List<String> PHASE_SEQUENCE = [K.phase_startup, K.phase_transformation, K.phase_difference, K.phase_writeout];
  
  TaskExecution(Map bean) : super(bean);
  
  String get id => get(K.id);
  
  bool get running => !completed && !failed;
  
  bool isPhaseAfter(String target) => PHASE_SEQUENCE.indexOf(phase)>PHASE_SEQUENCE.indexOf(target);
  
  bool get transformed => isPhaseAfter(K.phase_transformation);
  bool get difference => isPhaseAfter(K.phase_difference);
  
  bool get completed => status == K.status_completed;
  bool get failed => status == K.status_failed;
  
  String get status => get(K.status);
  String get phase => get(K.phase);
  
  Endpoint get source => new Endpoint.fromBean(get(K.source));
  Endpoint get target => new Endpoint.fromBean(get(K.target));
  
  Task get task => new Task.fromBean(get(K.task));
  
  bool get differenceOperation => task.operation != Operation.PUBLISH;
  
}


class RunningTask extends Observable {
  
  static TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  @observable
  Task task;

  @observable
  bool running = false;

  @observable
  ErrorResponse error;

  @observable
  TaskExecution execution;
  
  Timer executionPoller;
  
  @observable
  bool canCancel = false;

  @observable
  Result transform = new Result();
  
  @observable
  Result target = new Result();

  @observable
  Result diff = new Result();
  
  @observable
  String status;
  
  RunningTask(this.task);
  
  RunningTask.fromExecution(this.execution) {
    status = execution.status;
    task = execution.task;
  }
  
  void resetError() {
    error = null;
  }

  void runTask() {
    running = true;
    status = TEK.status_submitted;
    resetError();
    execution = null;
    transform.clean();
    diff.clean();
    target.clean();
    canCancel = false;
  }

  void executionUpdate(TaskExecution update) {
    execution = update;
    status = update.status;
    running = update.running;
    task = update.task;
    
    //we don't know the first update, so we set it always true
    canCancel = true;
    if (!update.running) stopTask();
  }

  void taskFailed(ErrorResponse reason) {
    error = reason;
    status = TEK.status_failed;
    stopTask();
  }
  
  void stopTask() {
    running = false;
    canCancel = false;
   if (executionPoller!=null) executionPoller.cancel();
  }
  
}

class HasTaskIcons {
  static TaskExecutionKeys _TEK = const TaskExecutionKeys();
  static Map<String,String> icons = {_TEK.status_submitted : "cloud-upload", 
                                     _TEK.status_started : "cloud-upload",
                                     _TEK.status_transformed : "cloud",
                                     _TEK.status_modified : "cloud-queue",
                                     _TEK.status_completed:"cloud-done",
                                     _TEK.status_failed:"warning"};
  
  String toIcon(String status) => status!=null? icons[status] :"";
}


@Injectable()
class Tasks extends EditableListItems<EditableModel<Task>> {
  
  containsLabel($) => data.any((EditableTask eq)=>eq!=selected && eq.model.label!=null && eq.model.label.toLowerCase() == $.toLowerCase());
}

@Injectable()
class TasksQueriesModel extends QuerySubPageModel {
  TasksQueriesModel(EventBus bus, TasksQueriesService service, TasksQueries storage) : super(bus, service, storage);
}

@Injectable()
class TasksQueries extends Queries {
}

@Injectable()
class TasksEndpointsModel extends EndpointSubPageModel {
  TasksEndpointsModel(EventBus bus, TasksEndpointsService service, TasksEndpoints storage) : super(bus, service, storage);
}

@Injectable()
class TasksEndpoints extends Endpoints {
}
