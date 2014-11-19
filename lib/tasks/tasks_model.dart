part of tasks;

class Task extends EditableGradeEntity with Filters {
  
  
  static final String id_field = "http://gradesystem.io/onto#id";  
  
  static final String name_field = "http://gradesystem.io/onto#uri";  
  static final String label_field = "http://www.w3.org/2000/01/rdf-schema#label";
  
  static final String operation_field = "http://gradesystem.io/onto/task.owl#operation";
  
  static final String source_endpoint_field = "http://gradesystem.io/onto/task.owl#source_endpoint";
  static final String source_graph_field = "http://gradesystem.io/onto/task.owl#source_graph";
  
  static final String target_endpoint_field = "http://gradesystem.io/onto/task.owl#target_endpoint";
  static final String target_graph_field = "http://gradesystem.io/onto/task.owl#target_graph";
  
  static final String query_field = "http://gradesystem.io/onto/task.owl#transform";
  static final String note_field = "http://www.w3.org/2004/02/skos/core#editorialNote";
  
  static final String creator_field = "http://purl.org/dc/terms/creator";

  
  Task.fromBean(Map bean) : super(bean) {
    onBeanChange([label_field], ()=>notifyPropertyChange(#label, null, label));
    onBeanChange([name_field], () => notifyPropertyChange(#name, null, name));
    onBeanChange([operation_field], ()=>notifyPropertyChange(#operation, null, operation));
  }
  
  Task() : this.fromBean({
          id_field: "",
          name_field: ""
        });
  
  String get key => get(id_field);
  
  @observable
  String get name => get(name_field);
  set name(String value) {
    set(name_field, value);
    notifyPropertyChange(#name, null, value);
  }

  String get label => get(label_field);
  
  Operation get operation => Operation.parse(get(operation_field));
  set operation(Operation operation) {
    set(operation_field, operation!=null?operation.value:null);
    notifyPropertyChange(#operation, null, operation);
  } 
  
  Task clone() {
    return new Task.fromBean(new Map.from(bean));
  }
}

class EditableTask extends EditableModel<Task> {
  EditableTask(Task task) : super(task);
  
}

class Operation {
  
  static UnmodifiableListView<Operation> values = new UnmodifiableListView([PUBLISH, ADD, REMOVE]);
  
  static Operation parse(String value) => values.firstWhere((Operation o)=> o._value == value, orElse:()=>null);
  
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


  TasksModel(EventBus bus, TasksService service, Tasks storage):super(bus, service, storage, generate) {
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
