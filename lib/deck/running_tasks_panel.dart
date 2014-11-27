part of deck;

@CustomTag("running-tasks-panel")
class RunningTasksPanel extends PolymerElement with Filters, Dependencies {

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


}
