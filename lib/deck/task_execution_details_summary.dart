part of deck;

@CustomTag("task-execution-details-summary") 
class TaskExecutionDetailsSummary extends View {
   
  @published
  TaskExecution item;
  
  @published
  bool selected;
  
  TaskExecutionDetailsSummary.created() : super.created();

  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  @ComputedProperty("item.bean[TEK.status]")
  String get status => get(item,TEK.status);

  
  void runTask() {
    fire("run", detail:item);
  }
  
}
