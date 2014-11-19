part of tasks;

@CustomTag("task-details-summary") 
class TaskDetailsSummary extends PolymerElement with Filters {
   
  @published
  EditableTask item;
  
  @published
  bool selected;
  
  TaskDetailsSummary.created() : super.created();

  bool get predefined => item.model.bean[Endpoint.predefined_field]==true;

  String get label_key => Task.label_field;
  
  @ComputedProperty("item.model.bean[label_key]")
  String get label {
  
    String label = "(label?)";
    
    if (item!=null) {
      
      String current_label= item.model.get(label_key);
      
      label = (current_label==null || current_label.isEmpty)? label : current_label;
      
    }
    
    return label;
      
  }
  
  void removeItem() {
    fire("remove-item", detail:item);
  }
  
  void cloneItem() {
    fire("clone-item", detail:item);
  }
  
}
