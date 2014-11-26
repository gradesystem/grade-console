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

  
  void onRunTask(event, detail, target) {
   
  }

}
