part of tasks;

@CustomTag("task-playground") 
class TaskPlayground extends PolymerElement with Filters {
  
  TaskKeys K = const TaskKeys();  
  TaskExecutionKeys TEK = const TaskExecutionKeys();
  
  @observable
  int executionArea = 0;
  
  @published
  EditableTask editableTask;
  
  @observable
  bool isactive;
  
  TaskPlayground.created() : super.created();
  
  void attributeChanged(name, oldValue, newValue) {
     super.attributeChanged(name, oldValue, newValue);
     if (name == "active") isactive =  attributes.containsKey('active');
   }
  
  String get publish_operation => 'http://gradesystem.io/onto/task.owl#publish';

  String get predefined_key => Query.predefined_field;
  String get target_key => Query.target_field;
  
  String get endpoint_name_key => Endpoint.name_field;
  
  @ComputedProperty("editableTask.model.bean[K.transform]") 
  String get transformQuery => editableTask!=null?editableTask.model.bean[K.transform]:"";
  void set transformQuery(String exp) {if (editableTask!=null) editableTask.model.bean[K.transform] = exp;}
  
  @ComputedProperty("editableTask.model.bean[K.diff]") 
  String get differenceQuery => editableTask!=null?editableTask.model.bean[K.diff]:"";
  void set differenceQuery(String exp) {editableTask.model.bean[K.diff] = exp;}
  
  @ComputedProperty("editableTask.model.bean[K.op]") 
  bool get hideDifferenceQuery => editableTask!=null?editableTask.model.bean[K.op] == publish_operation:false;
  
  @ComputedProperty("editableTask.model.bean[predefined_key]") 
  bool get editable => editableTask!=null?editableTask.model.bean[Query.predefined_field]==false:false;
  
  @ComputedProperty("editableTask.model.name")  
  String get title => editableTask!=null?(editableTask.model.name == null || editableTask.model.name.isEmpty?"(name?)":suffix(editableTask.model.name)):"";
  
  String errorMessage()   {
  
    return editableTask.lastError.isClientError()?
                      "Uhm, may be this query is broken? Make sure it's a well-formed SELECT, CONSTRUCT, or DESCRIBE.":
                      "Ouch. Something went horribly wrong...";
  
  }
  
  void onBack() {
    fire("back");
  }
  
  void onButtonClick() {
    if (editableTask.taskRunning) fire("cancel", detail:editableTask);
    else fire("run", detail:editableTask);
  }
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
    //($["detailsbutton"] as Element).text = collapse.opened?"Hide details":"Show details";
  }

}
