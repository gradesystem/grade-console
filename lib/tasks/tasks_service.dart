part of tasks;

final String _path = "catalogue";

@Injectable()
class TasksService extends EditableListService<Task> {

  static String EXECUTIONS_PATH = "executions";
  static String URI_PARAMETER = "uri";

  TasksService() : super(_path, "tasks", "task", (Map json) => new Task.fromBean(json));


  Future<bool> delete(Task item, [Map<String, String> parameters]) {
    return super.delete(item, addUri(parameters, item));
  }


  Future<TaskExecution> runTask(Task task) {
    String path = "$all_path/$EXECUTIONS_PATH";
    return http.postJSon(path, JSON.encode(task.bean), parameters: parameters(task)).then((json) => new TaskExecution(json));
  }

  Future<TaskExecution> pollTaskExecution(TaskExecution execution) {

    String path = "$all_path/$EXECUTIONS_PATH/${execution.id}";

    return http.getJSon(path).then((json) => new TaskExecution(json));
  }

  Map<String, String> parameters(Task task) => addUri({}, task);

  Map<String, String> addUri(Map<String, String> parameters, Task task) {
    Map expandedParameters = parameters!=null?new Map.from(parameters):{};
    expandedParameters[URI_PARAMETER] = task.id;
    return expandedParameters;
  }

  String getItemPath(String key) => "$single_item_path";

}

@Injectable()
class TasksQueriesService extends QueryService {
  TasksQueriesService() : super(_path);
}

@Injectable()
class TasksEndpointsService extends EndpointsService {
  TasksEndpointsService() : super(_path);
}
