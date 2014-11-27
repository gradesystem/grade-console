part of deck;

@CustomTag("runnable-tasks-panel")
class RunnableTasksPanel extends PolymerElement with Filters {

  @observable
  String kfilter = '';

  @published
  TasksModel model;

  RunnableTasksPanel.created() : super.created();

  Tasks get items => model.storage;

  void refresh() {
    model.loadAll();
  }

  void runTask(event, detail, target) {
    model.runTask(detail);
  }

}
