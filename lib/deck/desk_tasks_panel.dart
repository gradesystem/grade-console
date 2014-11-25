part of deck;

@CustomTag("deck-tasks-panel")
class TasksPanel extends PolymerElement with Filters {

  @observable
  String kfilter = '';

  @published
  TasksModel model;

  TasksPanel.created() : super.created();

  Tasks get items => model.storage;

  void refresh() {
    model.loadAll();
  }

  
  void onRunTask(event, detail, target) {
   
  }

}
