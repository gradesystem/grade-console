
part of tasks;

final String _path = "catalogue";

@Injectable()
class TasksService extends EditableListService<Task> {
  TasksService() : super(_path, "tasks", "task", toTask);
  
  
  
  Future<TaskExecution> runTask(Task task) {

    //TODO
     String path = "submit";

     return http.post(path, JSON.encode(task.bean)).then((response) => new TaskExecution(JSON.decode(response)));
   }
  
  static Task toTask(Map json) {
    return new Task.fromBean(json);
  }
}

@Injectable()
class TasksQueriesService extends QueryService {
  TasksQueriesService() : super(_path);
}

@Injectable()
class TasksEndpointsService extends EndpointsService {
  TasksEndpointsService() : super(_path);
}

