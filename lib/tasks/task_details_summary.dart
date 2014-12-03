part of tasks;

@CustomTag("task-details-summary") 
class TaskDetailsSummary extends View {
   
  @published
  EditableTask item;
  
  @published
  bool selected;
  
  TaskDetailsSummary.created() : super.created();

  TaskKeys K = const TaskKeys();

  @ComputedProperty("item.model.bean[K.target_graph]")
  String get target =>get(item,K.target_graph);
  
  @ComputedProperty("item.model.bean[K.label]")
  String get label => get(item,K.label);
  
  void removeItem() {
    fire("remove-item", detail:item);
  }
  
  void cloneItem() {
    fire("clone-item", detail:item);
  }
  
}
