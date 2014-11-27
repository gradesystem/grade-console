part of deck;

@CustomTag("running-task-details-summary") 
class RunningTaskDetailsSummary extends View {
   
  @published
  RunningTask item;
  
  @published
  bool selected;
  
  @ComputedProperty("item item.execution")
  String get label {
    if (item!=null) return (item.execution!=null)?item.execution.task.label:item.launchedTask.label;
    return null;
  }
  
  RunningTaskDetailsSummary.created() : super.created();

  void stopExecution() {
    fire("stop-execution", detail:item);
  }
  
  void removeExecution() {
    fire("remove-execution", detail:item);
  }
  
}
