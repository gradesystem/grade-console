part of deck;

@CustomTag("running-tasks-panel")
class RunningTasksPanel extends PolymerElement with Filters {

  @observable
  String kfilter = '';


  RunningTasksPanel.created() : super.created();
  
  void refresh() {}


}
