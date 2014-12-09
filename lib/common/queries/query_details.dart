part of queries;

@CustomTag("query-details") 
class QueryDetails extends View {
  
  QueryKeys K = const QueryKeys();  
  
  Map<String,List<Validator>> validators = {};
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('queries.selected')
  EditableQuery get item => queries==null?null:queries.selected;
  
  @published
  Queries queries;
  
  @published
  Endpoints endpoints;
  
  @published
  Refresh endpointRefresh;
  
  @observable
  List<Validator> nameValidators = [];
  
  @observable
  EditableEndpoint target;
  
  @observable
  List<String> invalidGraphUris;
   
  QueryDetails.created() : super.created() {
    nameValidators.add(($) =>  $!=null && queries.containsName($)?"Not original enough, try again.":null);
  }
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  @ComputedProperty("item.model.bean[K.target]")
  String get targetId => get(item, K.target);
  
  @ObserveProperty("targetId endpoints.data")
  void updateTarget() {
    target = endpoints.findById(targetId);
  }
 
  refreshTargetGraphs() {
    endpointRefresh(target);
  }
  
  //workaround to observe property not listening to target.model.graphs
  @ComputedProperty("target.model.graphs")
  List<Graph> get graphs => target!=null?target.model.graphs:[];
  
  @ObserveProperty("item.model.graphs graphs")
  void calculateInvalidGraphUris() {
    invalidGraphUris = item!=null?item.model.graphs.where((uri)=>!graphs.any((Graph g)=>g.uri == uri)).toList():[];
    if (item!=null) item.fieldsInvalidity[K.graph] = invalidGraphUris.isNotEmpty;
  }

  @ComputedProperty("item.model.parameters")
  String get parameters {
    
    String params = '(none)';
    
    if (item!=null) {
      
      List<String> parameters = item.model.parameters;
      params = parameters.isEmpty? params :parameters.toString();
    }
    
    return params;
    
  }
  
}
