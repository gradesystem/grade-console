part of tasks;

@CustomTag("task-execution-panel")
class TaskExecutionPanel extends PolymerElement {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  String get endpoint_name_key => Endpoint.name_field;

  @published
  TaskExecution taskExecution;
  
  TaskExecutionPanel.created() : super.created();
  
}
