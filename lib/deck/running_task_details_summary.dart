part of deck;

@CustomTag("running-task-details-summary") 
class RunningTaskDetailsSummary extends View {
   
  @published
  RunningTask item;
  
  @published
  bool selected;
  
  RunningTaskDetailsSummary.created() : super.created();

  void stopExecution() {
    fire("stop-execution", detail:item);
  }
  
  void removeExecution() {
    fire("remove-execution", detail:item);
  }
  
}
