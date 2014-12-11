part of tasks;

@CustomTag("task-details")
class TaskDetails extends View {
  
  static String URI_PREFIX = "http://gradesystem.io/tasks#";
  static RegExp spaceExp = new RegExp(r'[\s]');
  
  @published
  EditableTask editable;

  GradeEnpoints endpoints;
  
  TaskKeys K = const TaskKeys();  
  
  Validator conditionalRequiredDiff ;
  Validator uniqueLabel;
  
  TaskDetails.created() : super.created() {
  
    endpoints = instanceOf(GradeEnpoints);
    Tasks tasks = instanceOf(Tasks);
    
    conditionalRequiredDiff = ($) => 
       get(editable,K.op)!=K.publish_op && ($==null || $.isEmpty)? "Please fill in this field.":null;
    
    uniqueLabel = ($) =>  $!=null && tasks.containsLabel($)?"Not original enough, try again.":null;
  }
  
  @ComputedProperty("editable.model.bean[K.source_endpoint]")
  EditableEndpoint get source => endpoints.findEditableEndpointById(get(editable,K.source_endpoint));
  set source(EditableEndpoint source) {/*IGNORE IT*/}
   
  @ComputedProperty("editable.model.bean[K.target_endpoint]")
  EditableEndpoint get target => endpoints.findEditableEndpointById(get(editable,K.target_endpoint));
   
  refreshSourceGraphs() {
    endpoints.refesh(get(editable,K.source_endpoint));
  }

  refreshTargetGraphs() {
    endpoints.refesh(get(editable,K.target_endpoint));
  }

  //workaround to selected binding not working: issue https://github.com/dart-lang/core-elements/issues/157
  @ObserveProperty("editable.model")
  void updateGraphs() {
    
    //$["sourceGraphs"].selected = getAll(editable,K.source_graph);
    $["targetGraphs"].selected = get(editable,K.target_graph);
 
  }

}
