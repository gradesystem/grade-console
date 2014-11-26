part of tasks;

@CustomTag("task-execution")
class TaskExecutionView extends View {
  
  @published
  TaskExecution execution;
  
  TaskExecutionKeys K = const TaskExecutionKeys();
  
  Map icons;

  TaskExecutionView.created() : super.created() {
    
    icons={K.status_completed:"cloud-done"};
  }
  

  @ComputedProperty("execution.bean[K.status]")
  String get icon => icons[execution.get(K.status)];
 
}
