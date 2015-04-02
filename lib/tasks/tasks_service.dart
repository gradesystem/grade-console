part of tasks;

final String _service_path = "catalogue";

@Injectable()
class TasksService extends EditableListService<Task> {

  static String EXECUTIONS_PATH = "executions";
  static String URI_PARAMETER = "uri";

  TasksService() : super(_service_path, "tasks", "task", (Map json) => new Task.fromBean(json));

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
  
  TaskExecutionsService() : super(_service_path, "tasks/executions", "tasks/executions", (json) => new TaskExecution(json));
  
  Future<TaskExecution> pollTaskExecution(TaskExecution execution) 
    => get(execution.id);
  
  Future<TaskExecution> stopTaskExecution(TaskExecution execution) 
    => http.postJSon(getItemPath(execution.id), "").then(generator);

  Future<ResultTable> getTransformResult(TaskExecution execution, {String uri, int limit})     
    => _getResult(execution, "transform", uri:uri,limit:limit);

  Future<ResultTable> getDifferenceResult(TaskExecution execution, {String uri, int limit})     
    => _getResult(execution, "difference", uri:uri,limit:limit); 
  
  Future<ResultTable> getTargetResult(TaskExecution execution, {String uri, int limit})     
    => _getResult(execution, "target", uri:uri,limit:limit);
  
  Future<ResultTable> _getResult(TaskExecution execution, String resultpath, {String uri, int limit})     
     => http.get("${getItemPath(execution.id)}/results/$resultpath", acceptedMediaType:MediaType.SPARQL_JSON, parameters: getParameters(uri:uri,limit:limit))
     .then((response) => new ResultTable(http.decode(response)));
  
  Map getParameters({String uri, int limit}) {
    Map parameters = {};
    if (uri!=null) parameters["uri"] = uri;
    if (limit!=null) parameters["grade_limit"] = "$limit";
    return parameters;
  }
 
  Future<bool> delete(TaskExecution execution) {
    return http.delete(getItemPath(execution.id)).then((response) => true);
  }
}

