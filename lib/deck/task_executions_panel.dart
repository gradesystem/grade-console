part of deck;

@CustomTag("task-executions-panel")
class TaskExecutionsPanel extends PolymerElement with Filters, Dependencies {

  @observable
  String kfilter = '';
  
  @published
  DeckPageModel model;


  TaskExecutionsPanel.created() : super.created() {
    EventBus bus = instanceOf(EventBus);
    bus.on(TaskLaunched).listen((_) {
      refresh();
     });
  }
  

  TaskExecutions get items => model.storage;

  void refresh() {
    model.loadAll();
  }


}
