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

  Future<TaskExecution> runTask(Task task) 
    => http.postJSon("$all_path/$EXECUTIONS_PATH", "", parameters: parameters(task)).then((json) => new TaskExecution(json));
  
  Future<TaskExecution> runSandboxTask(Task task) 
    => http.postJSon("$all_path/sandbox/$EXECUTIONS_PATH", JSON.encode(task.bean)).then((json) => new TaskExecution(json));

  Map<String, String> parameters(Task task) => addUri({}, task);

  Map<String, String> addUri(Map<String, String> parameters, Task task) {
    Map expandedParameters = parameters!=null?new Map.from(parameters):{};
    expandedParameters[URI_PARAMETER] = task.id;
    return expandedParameters;
  }

  String getItemPath(String key) => "$single_item_path";

}


@Injectable()
class TaskExecutionsService extends ListService<TaskExecution> {
  
  TaskExecutionsService() : super(_path, "tasks/executions", "tasks/executions", (json) => new TaskExecution(json));
  
  Future<TaskExecution> pollTaskExecution(TaskExecution execution) 
    => get(execution.id);
  
  Future<TaskExecution> stopTaskExecution(TaskExecution execution) 
    => http.delete(getItemPath(execution.id)).then((response) => true);  

  Future<QueryResult> getTransformResult(TaskExecution execution)     
    => http.get("${getItemPath(execution.id)}/results/transform", acceptedMediaType:MediaType.SPARQL_JSON).then((response) => new QueryResult(response, http.decode(response)));
  
  Future<QueryResult> getTargetResult(TaskExecution execution)     
    => http.get("${getItemPath(execution.id)}/results/target", acceptedMediaType:MediaType.SPARQL_JSON).then((response) => new QueryResult(response, http.decode(response)));
 
}



@Injectable()
class TasksQueriesService extends QueryService {
  TasksQueriesService() : super(_path);
}

@Injectable()
class TasksEndpointsService extends EndpointsService {
  TasksEndpointsService() : super(_path);
}
