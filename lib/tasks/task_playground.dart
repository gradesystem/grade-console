part of tasks;

@CustomTag("task-playground") 
class TaskPlayground extends PolymerElement with Filters, Dependencies {
  
  TaskKeys K = const TaskKeys();  
  
  @published
  EditableTask editableTask;
  
  @observable
  bool isactive;
  
  @observable
  GradeEnpoints gradeEndpoints;
  
  @observable
  int resultsLimit = 25;
  
  TaskPlayground.created() : super.created(){
    
    gradeEndpoints = instanceOf(GradeEnpoints);
  }
  
  void attributeChanged(name, oldValue, newValue) {
     super.attributeChanged(name, oldValue, newValue);
     if (name == "active") isactive =  attributes.containsKey('active');
   }
  
  @ComputedProperty("editableTask.model.bean[K.transform]") 
  String get transformQuery => editableTask!=null?editableTask.model.bean[K.transform]:"";
  void set transformQuery(String exp) {if (editableTask!=null) editableTask.model.bean[K.transform] = exp;}
  
  @ComputedProperty("editableTask.model.bean[K.diff]") 
  String get differenceQuery => editableTask!=null?editableTask.model.bean[K.diff]:"";
  void set differenceQuery(String exp) {if (editableTask!=null) editableTask.model.bean[K.diff] = exp;}
  
  @ComputedProperty("editableTask.model.bean[K.op]") 
  bool get hideDifferenceQuery => editableTask!=null?editableTask.model.bean[K.op] == K.publish_op:false;
  
  @ComputedProperty("editableTask.model.bean[K.label]")  
  String get paneltitle => editableTask!=null?(editableTask.model.label == null || editableTask.model.label.isEmpty?"(label?)":editableTask.model.label):"";
  
  @ComputedProperty("editableTask.synching")
  bool get loading => editableTask!=null && editableTask.synching;
  
  void onBack() {
    fire("back");
  }
  
  void onEdit() {
    editableTask.startEdit();
  }
  
  void onCancel() {
    fire("cancel-editing");
  }

  void onSave() {
    fire("save");
  }
  
  void onButtonClick() {
    if (editableTask.playgroundRunningTask.running) fire("cancel", detail:editableTask);
    else fire("run", detail:{"limit":resultsLimit, "task":editableTask});
  }

}
