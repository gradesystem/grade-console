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
  
  Future<TaskExecution> runSandboxTask(Task task) {
    //tmp workaround to limit the result size
    Map bean = new Map.from(task.bean);
    bean[Task.K.transform] = bean[Task.K.transform]+ " limit 1000";
    if (bean[Task.K.diff] != null) bean[Task.K.diff] = bean[Task.K.diff]+ " limit 1000";
    return http.postJSon("$all_path/sandbox/$EXECUTIONS_PATH", JSON.encode(bean)).then((json) => new TaskExecution(json));
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
class TaskExecutionsService extends ListService<TaskExecution> {
  
  TaskExecutionsService() : super(_service_path, "tasks/executions", "tasks/executions", (json) => new TaskExecution(json));
  
  Future<TaskExecution> pollTaskExecution(TaskExecution execution) 
    => get(execution.id);
  
  Future<TaskExecution> stopTaskExecution(TaskExecution execution) 
    => http.delete(getItemPath(execution.id)).then((response) => true);  

  Future<ResulTable> getTransformResult(TaskExecution execution, [String uri])     
    => _getResult(execution, "transform", uri);

  Future<ResulTable> getDifferenceResult(TaskExecution execution, [String uri])     
    => _getResult(execution, "difference", uri); 
  
  Future<ResulTable> getTargetResult(TaskExecution execution, [String uri])     
    => _getResult(execution, "target", uri);
  
  Future<ResulTable> _getResult(TaskExecution execution, String resultpath, [String uri])     
     => http.get("${getItemPath(execution.id)}/results/$resultpath", acceptedMediaType:MediaType.SPARQL_JSON, parameters: uri!=null?{"uri":uri}:{})
     .then((response) => new ResulTable(http.decode(response)));
  
 
  Future<bool> delete(TaskExecution execution) {
    return http.delete(getItemPath(execution.id)).then((response) => true);
  }
}

