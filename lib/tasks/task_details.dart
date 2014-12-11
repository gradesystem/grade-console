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
  
  //we need this list for the graphs panel
  @observable
  ObservableList<String> targetGraphs;
  
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
  set target(EditableEndpoint source) {/*IGNORE IT*/}
   
  refreshSourceGraphs() {
    endpoints.refesh(get(editable,K.source_endpoint));
  }

  refreshTargetGraphs() {
    endpoints.refesh(get(editable,K.target_endpoint));
  }
  
  @ComputedProperty("editable.model.bean[K.target_graph]")
  String get targetGraph => getOrNull(editable, K.target_graph); 
  
  @ObserveProperty("targetGraph")
  void updateTargetGraphs() {
    targetGraphs = toObservable(targetGraph!=null?[targetGraph]:[]);
  }
  
  @ObserveProperty("targetGraphs")
  void syncTargetGraphs() {
    String selectedGraph = targetGraphs!=null && targetGraphs.isNotEmpty?targetGraphs.first:null;
    //avoid loops of notifications
    if (targetGraph!=selectedGraph) set(editable, K.target_graph, selectedGraph);
  }

}
