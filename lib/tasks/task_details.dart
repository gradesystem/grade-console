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

  
  @observable
  ObservableList<String> myselected = new ObservableList();
      
  void printBean(){
   print("items: ${item.bean[source_graph_key]}");
  
  }
  
  @ComputedProperty("item.bean[source_endpoint_key]")
  String get sourceEnpointId => item!=null?item.bean[source_endpoint_key]:null;
  
  @ComputedProperty("sourceEnpointId") //modify after model update
  GradeEndpoint get sourceEndpoint => gradeEndpoints!=null?gradeEndpoints.findByURI(sourceEnpointId):null;
  
  @ObserveProperty("sourceEndpoint")
  void refreshSourceEnpointGraphs() {
    if (sourceEndpoint!=null) sourceEndpoint.refresh();
  }
  
  ItemLabelProvider get endpointLabelProvider => (GradeEndpoint item)=>item.endpoint.name;
  ItemIdProvider get endpointIdProvider => (GradeEndpoint item)=>item.uri;

  @published
  bool editable = false;

  @published
  Task item;
  
  GradeEnpoints gradeEndpoints;

  TaskDetails.created() : super.created() {
    gradeEndpoints = instanceOf(GradeEnpoints);
  }
  
  //workaround to selected binding not working: issue https://github.com/dart-lang/core-elements/issues/157
  @ObserveProperty("item")
  void updateSourceGraphsSelected() {
    if (item!=null && $["sourceGraphsSelector"]!=null) $["sourceGraphsSelector"].selected = item.bean[source_graph_key];
  }

}
