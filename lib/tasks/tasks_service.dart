
part of tasks;

final String _path = "catalogue";

@Injectable()
class TasksService extends EditableListService<Task> {
  
  static String EXECUTIONS_PATH = "executions";
  
  TasksService() : super(_path, "tasks", "task", toTask);
  
  
  
  Future<TaskExecution> runTask(Task task) {
     return http.post(EXECUTIONS_PATH, JSON.encode(task.bean)).then((response) => new TaskExecution(JSON.decode(response)));
   }
  
  Future<TaskExecution> pollTaskExecution(String executionId) {
    
    String path = "$EXECUTIONS_PATH/${executionId}";
    
     return http.getJSon(path).then((response) => new TaskExecution(JSON.decode(response)));
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

