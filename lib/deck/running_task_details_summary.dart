part of deck;

@CustomTag("running-task-details-summary") 
class RunningTaskDetailsSummary extends View with HasTaskIcons {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
   
  @published
  RunningTask item;
  
  @published
  bool selected;
  
  @observable
  String startTime = "n/a";
  
  @observable
  String duration = "n/a";
  
  @observable
  String phase = "n/a";
  
  RunningTaskDetailsSummary.created() : super.created();
  
  String available(String value) => value!=null?value:"n/a";
  
  void stopExecution() {
    fire("stop-execution", detail:item);
  }
  
  void removeExecution() {
    fire("remove-execution", detail:item);
  }
  

  @ObserveProperty("item.execution")
    void setInfo() {
      if (item == null || item.execution == null) return;
      startTime = available(item.execution.bean[TEK.startTime]);
      duration = available(item.execution.bean[TEK.duration]);
      phase = available(item.execution.bean[TEK.phase]);
  }
  
}
