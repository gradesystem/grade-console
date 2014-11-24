part of tasks;

class TaskKeys {
  
     const TaskKeys();
    
     final String id = "http://gradesystem.io/onto#id";  
       
     final String uri = "http://gradesystem.io/onto#uri";  
     final String label = "http://www.w3.org/2000/01/rdf-schema#label";
     
     final String op = "http://gradesystem.io/onto/task.owl#operation";
     final String publish_op = 'http://gradesystem.io/onto/task.owl#publish';
     final String add_op ='http://gradesystem.io/onto/task.owl#add';
     final String remove_op  ='http://gradesystem.io/onto/task.owl#remove';
     
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
    onBeanChange([K.label], ()=>notifyPropertyChange(#label, null, label));
    onBeanChange([K.uri], () => notifyPropertyChange(#name, null, name));
    onBeanChange([K.op], ()=>notifyPropertyChange(#operation, null, operation));
  }

  Task() : this.fromBean({
          K.id: "",
          K.uri: ""
        });
  
  String get id => get(K.id);
  set id(String value) => set(K.id, value);
  
  @observable
  String get name => get(K.uri);
  set name(String value) {
    set(K.uri, value);
    notifyPropertyChange(#name, null, value);
  }

  String get label => get(K.label);
  
  Operation get operation => Operation.parse(get(K.op));
  set operation(Operation operation) {

    set(K.op, operation!=null?operation.value:null);
    notifyPropertyChange(#operation, null, operation);
  }

  Task clone() {
    return new Task.fromBean(new Map.from(bean));
  }
}

class EditableTask extends EditableModel<Task> with Keyed {

  @observable
  bool queryRunning = false;

  @observable
  ErrorResponse lastError;

  @observable
  QueryResult lastQueryResult;

  bool _dirty = false;

  EditableTask(Task task) : super(task) {
    
    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);

    //when query or parameters are edited we reset the last error
    onPropertyChange(this, #dirty, resetLastError);
  }
  
  get(key) => model.get(key);
  set(key,value) => model.set(key, value);


  void _listenNewModel() {

    model.changes.listen((_) => _setDirty(true));

    onPropertyChange(this, #model, () => _setDirty(false));
  }

  void _setDirty(bool dirty) {
    _dirty = dirty;
    notifyPropertyChange(#dirty, null, _dirty);
  }

  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;

  void resetLastError() {
    lastError = null;
  }


  void runQuery() {
    queryRunning = true;
    _setDirty(false);
    resetLastError();
    lastQueryResult = null;
  }

  void queryResult(QueryResult result) {
    queryRunning = false;
    lastQueryResult = result;
  }

  void queryFailed(ErrorResponse reason) {
    queryRunning = false;
    lastError = reason;
  }
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


  TasksModel(EventBus bus, TasksService service, Tasks storage) : super(bus, service, storage, generate) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }

  TasksService get taskService => service;

  static EditableTask generate([Task item]) {
    if (item == null) return new EditableTask(new Task());
    return new EditableTask(item);
  }

}

@Injectable()
class Tasks extends EditableListItems<EditableModel<Task>> {
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
