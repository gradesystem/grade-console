part of deck;

@CustomTag("task-executions-panel")
class TaskExecutionsPanel extends PolymerElement with Filters {

  @observable
  String kfilter = '';
  
  @published
  DeckPageModel model;


  TaskExecutionsPanel.created() : super.created();
  

  TaskExecutions get items => model.storage;

  void refresh() {
    //model.loadAll();
  }


}
