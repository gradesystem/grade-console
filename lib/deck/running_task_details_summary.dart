part of deck;

@CustomTag("running-task-details-summary") 
class RunningTaskDetailsSummary extends View with HasTaskIcons {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
   
  @published
  RunningTask item;
  
  @published
  bool selected;
  
  RunningTaskDetailsSummary.created() : super.created();
  
  
  String available(String $) => ($==null || $.isEmpty) ? "n/a" : $;

  void stopExecution() {
    fire("stop-execution", detail:item);
  }
  
  void removeExecution() {
    fire("remove-execution", detail:item);
  }
  
}
