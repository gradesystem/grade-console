part of deck;

@CustomTag("runnable-task-details-summary") 
class RunnableTaskDetailsSummary extends View {
   
  @published
  EditableTask item;
  
  @published
  bool selected;
  
  RunnableTaskDetailsSummary.created() : super.created();

  TaskKeys K = const TaskKeys();

  @ComputedProperty("item.model.bean[K.target_graph]")
  String get target =>get(item,K.target_graph);
  
  @ComputedProperty("item.model.bean[K.label]")
  String get label => get(item,K.label);

  
  void runTask() {
    fire("run", detail:item);
  }
  
}
