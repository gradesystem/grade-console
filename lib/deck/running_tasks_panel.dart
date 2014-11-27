part of deck;

@CustomTag("running-tasks-panel")
class RunningTasksPanel extends PolymerElement with Filters, Dependencies {

  @observable
  String kfilter = '';
  
  @published
  DeckPageModel model;

  RunningTasksPanel.created() : super.created() {
  }

  RunningTasks get items => model.storage;

  void refresh() {
    model.loadAll();
  }


}
