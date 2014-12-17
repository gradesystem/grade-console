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
  }
  
  
  void onDescribeTransformUri(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"transform", "uri":detail, "runningTask":runningTask});
  }
  
  void onDescribeDiffUri(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"diff", "uri":detail, "runningTask":runningTask});
  }
  
  void onDescribeTargetUri(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"target", "uri":detail, "runningTask":runningTask});
  }
  
  void onLoadTransformResult() {
    fire("load-result", detail:{"type":"transform", "runningTask":runningTask});
  }
  
  void onLoadDiffResult() {
    fire("load-result", detail:{"type":"diff", "runningTask":runningTask});
  }
  
  void onLoadTargetResult() {
    fire("load-result", detail:{"type":"target", "runningTask":runningTask});
  }
  
}