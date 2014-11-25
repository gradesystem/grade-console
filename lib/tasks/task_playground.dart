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
  
  String get transform_query_key => K.transform;
  String get difference_query_key => K.diff;
  String get operation_key => K.op;
  String get predefined_key => Query.predefined_field;
  String get target_key => Query.target_field;
  
  @ComputedProperty("editableTask.model.bean[transform_query_key]") 
  String get transformQuery => editableTask!=null?editableTask.model.bean[transform_query_key]:"";
  void set transformQuery(String exp) {editableTask.model.bean[transform_query_key] = exp;}
  
  @ComputedProperty("editableTask.model.bean[difference_query_key]") 
  String get differenceQuery => editableTask!=null?editableTask.model.bean[difference_query_key]:"";
  void set differenceQuery(String exp) {editableTask.model.bean[difference_query_key] = exp;}
  
  @ComputedProperty("editableTask.model.bean[operation_key]") 
  bool get hideDifferenceQuery => editableTask!=null?editableTask.model.bean[operation_key] == publish_operation:false;
  
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
  
  void onRun() {
    fire("run", detail:editableTask);
  }
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
    //($["detailsbutton"] as Element).text = collapse.opened?"Hide details":"Show details";
  }

}
