part of deck;

@CustomTag("runnable-tasks-panel")
class RunnableTasksPanel extends ResizerPolymerElement with Filters, Dependencies {

  @observable
  String kfilter = '';

  DeckPageModel model;

  RunnableTasksPanel.created() : super.created() {
    model = instanceOf(DeckPageModel);
  }

  void refresh() {
    model.loadRunnable();
  }

  void runTask(event, detail, target) {
    model.runTask(detail);
  }
}
