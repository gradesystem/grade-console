part of deck;

@CustomTag("running-tasks-panel")
class RunningTasksPanel extends ResizerPolymerElement with Filters, Dependencies {

  @observable
  String kfilter = '';
  
  @observable
  DeckPageModel model;

  RunningTasksPanel.created() : super.created() {
    model = instanceOf(DeckPageModel);
  }

  void refresh() {
    model.loadAll();
  }

  void stopExecution(event,detail,target) {
    model.cancelExecution(detail);
  }
  
  void removeExecution(event,detail,target) {
    model.removeExecution(detail);
  }
  
  void removeAllExecuted() {
    model.removeAllExecuted();
  }

}
