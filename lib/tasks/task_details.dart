part of tasks;

@CustomTag("task-details")
class TaskDetails extends PolymerElement with Filters, Dependencies {

  String get name_key => Task.name_field;
  String get label_key => Task.label_field;
  
  String get operation_key => Task.operation_field;
  
  String get source_endpoint_key => Task.source_endpoint_field;
  String get source_graph_key => Task.source_graph_field;
  
  String get target_endpoint_key => Task.target_endpoint_field;
  String get target_graph_key => Task.target_graph_field;
  
  String get query_key => Task.query_field;
  String get note_key => Task.note_field;
  
  String get creator_key => Task.creator_field;
  
  List<Operation> get operations => Operation.values;
  
  @published
  bool editable = false;

  @published
  Task item;
  
  GradeEnpoints gradeEndpoints;
  
  TaskDetails.created() : super.created() {
    gradeEndpoints = instanceOf(GradeEnpoints);
  }  

  @ComputedProperty("item.bean[source_endpoint_key]")
  String get sourceEnpointId => item!=null?item.bean[source_endpoint_key]:null;
  
  @ComputedProperty("sourceEnpointId")
  EditableEndpoint get sourceEnpoint => gradeEndpoints.findEditableEndpointByUri(sourceEnpointId);
   
  @ObserveProperty("sourceEnpointId")
  void refreshSourceEnpointGraphs() {
    if (sourceEnpointId!=null) gradeEndpoints.refesh(sourceEnpointId);
  }
  
  @ComputedProperty("item.bean[target_endpoint_key]")
  String get targetEnpointId => item!=null?item.bean[target_endpoint_key]:null;
  
  @ComputedProperty("targetEnpointId")
  EditableEndpoint get targetEnpoint => gradeEndpoints!=null?gradeEndpoints.findEditableEndpointByUri(targetEnpointId):null;
  
  @ObserveProperty("targetEnpoint")
  void refreshTargetEnpointGraphs() {
    if (targetEnpointId!=null) {
      gradeEndpoints.refesh(targetEnpointId);
      if (targetEnpoint!=null && !targetEnpoint.model.graphs.contains(targetEnpointId)) item.bean[target_graph_key] = null;
    }
  }

  //workaround to selected binding not working: issue https://github.com/dart-lang/core-elements/issues/157
  @ObserveProperty("item")
  void updateSourceGraphsSelected() {
    if (item!=null && $["sourceGraphsSelector"]!=null) $["sourceGraphsSelector"].selected = item.bean[source_graph_key];
  }

}
