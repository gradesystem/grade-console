part of deck;

@CustomTag("running-task-details-summary") 
class RunningTaskDetailsSummary extends View {
   
  @published
  RunningTask item;
  
  @published
  bool selected;
  
  RunningTaskDetailsSummary.created() : super.created();

  void stopTask() {
    fire("stop", detail:item);
  }
  
}
