part of deck;

@CustomTag("runnable-tasks-panel")
class RunnableTasksPanel extends PolymerElement with Filters, Dependencies {

  @observable
  String kfilter = '';

  DeckPageModel model;

  RunnableTasksPanel.created() : super.created() {
    model = instanceOf(DeckPageModel);
  }

  void refresh() {
    model.loadAll();
  }

  void runTask(event, detail, target) {
    model.runTask(detail);
  }

}
