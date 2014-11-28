part of tasks;

@CustomTag("running-task-panel")
class RunningTaskPanel extends PolymerElement {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  @observable
  int executionArea = 1;

  @published
  RunningTask runningTask;
  
  @published
  bool dirty = false;
  
  @published
  String paneltitle;
  
  @observable
  bool expanded;
  
  RunningTaskPanel.created() : super.created();
  
  void ready() {
    expanded = querySelector("[task-tab]")!=null;
  }
  
  
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