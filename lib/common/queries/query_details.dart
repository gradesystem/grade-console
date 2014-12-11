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
