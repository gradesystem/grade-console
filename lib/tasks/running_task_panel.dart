part of tasks;

@CustomTag("running-task-panel")
class RunningTaskPanel extends PolymerElement {
  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  int WHITE_PANEL = 0;
  int ERROR_PANEL = 1;
  int EXECUTION_PANEL = 2;
  
  @observable
  int resultArea = 0;
  
  @observable
  int executionArea;

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
    expanded = childNodes.isNotEmpty;
    resetArea();
  }
  
  @ObserveProperty("runningTask.running expanded")
  void resetArea() {
    executionArea = expanded?1:0;
  }
  
  @ObserveProperty("runningTask runningTask.error runningTask.execution")
  void updateResultArea() {
    resultArea = WHITE_PANEL;
    
    if (runningTask != null) {
      if (runningTask.error!=null) resultArea = ERROR_PANEL;
      if (runningTask.execution!=null) resultArea = EXECUTION_PANEL;
    }
  }  
  
  @ComputedProperty("runningTask.error")
   String get errorMessage {
   
    return runningTask!=null && runningTask.error!=null && runningTask.error.isClientError()?
                          "Uhm, may be the task queries are broken ?":
                          "Ouch. Something went horribly wrong...";
   
   }
   
  
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
  }
  
  
  void onEatTransformCrumb(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"transform", "crumb":detail, "runningTask":runningTask});
  }
  
  void onEatDiffCrumb(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"diff", "crumb":detail, "runningTask":runningTask});
  }
  
  void onEatTargetCrumb(event, detail, target) {
    event.stopImmediatePropagation();
    fire("describe-uri", detail:{"type":"target", "crumb":detail, "runningTask":runningTask});
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