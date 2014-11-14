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
  
  ItemLabelProvider get operationLabelProvider => (Operation item)=>item.label;
  ItemIdProvider get operationIdProvider => (Operation item)=>item.value;
  
  @observable
  List<String> graphs = ["http://semanticrepository/public/graph/CL_FAO_VESSEL_TYPES"];
  
  @observable
  ObservableList<String> myselected = new ObservableList();
      
  void printBean(){
   print("items: ${item.bean[source_graph_key]}");
  
  }
  
  getTypeName(dynamic obj) {
    return reflect(obj).type.reflectedType.toString();
  }
  
  @ComputedProperty("item.bean[source_endpoint_key]")
  String get sourceEnpointId => item!=null?item.bean[source_endpoint_key]:null;
  
  @ComputedProperty("sourceEnpointId")
  GradeEndpoint get sourceEndpoint => gradeEndpoints!=null?gradeEndpoints.find(sourceEnpointId):null;
  
  @ObserveProperty("sourceEndpoint")
  void refreshSourceEnpointGraphs() {
    if (sourceEndpoint!=null && sourceEndpoint.endpoint.graphs == null) sourceEndpoint.refresh();
  }
  
  ItemLabelProvider get endpointLabelProvider => (GradeEndpoint item)=>item.endpoint.name;
  ItemIdProvider get endpointIdProvider => (GradeEndpoint item)=>item.id;

  @published
  bool editable = false;

  @published
  Task item;
  

  GradeEnpoints gradeEndpoints;

  TaskDetails.created() : super.created() {
    gradeEndpoints = instanceOf(GradeEnpoints);
  }
  
  @ObserveProperty("item")
  void updateSourceGraphsSelected() {
    if (item!=null && $["sourceGraphsSelector"]!=null) $["sourceGraphsSelector"].selected = item.bean[source_graph_key];
  }

}
