part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  
  List<String> fields = [Query.datasets_field,
                         Query.note_field,
                         Query.expression_field];
  
  static List<String> required_fields = [
                         Query.name_field,
                         Query.target_field,
                         Query.expression_field];
  
  
  Map<String,List<Validator>> validators = {};
  
  static List<String> area_fields = [Query.expression_field,Query.note_field];
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('queries.selected')
  EditableQuery get item => queries==null?null:queries.selected;
  
  @published
  Queries queries;
  
  @published
  Endpoints endpoints;
   
  QueryDetails.created() : super.created() {
    validators[
       Query.name_field]=[($) =>  $!=null && queries.containsName($)?"Not original enough, try again.":null];
  }
  
  //used in template to lookup (cannot bind static fields)
  String get endpoint_key => Query.endpoint_field;
  String get parameters_key => Query.parameters_field;
  String get target_key => Query.target_field;
  String get expression_key => Query.expression_field;
  String get name_key => Query.name_field;
  
  bool isAreaField(String key) {
    return area_fields.contains(key);
  }
  
  bool isRequiredField(String key) {
    return required_fields.contains(key);
  }
  
  List<Validator> validatorsFor(String key) {
    List<Validator> validators = this.validators[key];
    return validators==null?[]:validators;
  }
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  ItemLabelProvider get endpointLabelProvider => (Endpoint item)=>item.name;
  ItemIdProvider get endpointIdProvider => (Endpoint item)=>item.id;

  
  //we need to listen to length in order to be notified
  @ComputedProperty("endpoints.data.length")
  List<Endpoint> get targets {
    return endpoints==null?[]:endpoints.data.skipWhile((EditableEndpoint e)=>e.newModel).map((EditableEndpoint e)=> e.model).toList();
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

class Test extends Observable {
  ObservableList items = new ObservableList();
}
