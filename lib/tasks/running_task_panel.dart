part of tasks;

@CustomTag("running-task-panel")
class RunningTaskPanel extends PolymerElement {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  @observable
  int executionArea = 0;

  @published
  RunningTask runningTask;
  
  @published
  bool dirty = false;
  
  @published
  String paneltitle;
  
  RunningTaskPanel.created() : super.created();
  
  
  String errorMessage()   {
  
    return runningTask!=null && runningTask!=null?runningTask.error.isClientError()?
                      "Uhm, may be the task queries are broken ?":
                      "Ouch. Something went horribly wrong..."
                      :null;
  
  }
  
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
    //($["detailsbutton"] as Element).text = collapse.opened?"Hide details":"Show details";
  }
  
}