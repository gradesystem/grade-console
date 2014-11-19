part of endpoints;

@CustomTag("endpoint-details") 
class EndpointDetails extends PolymerElement with Filters {
  
  @published
  Endpoints items;
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  String get name_key =>  Endpoint.name_field;
  String get uri_key =>  Endpoint.uri_field;
  String get update_uri_key =>  Endpoint.update_uri_field;
  
  List<Validator> get name_validators => [($) => $!=null && items.containsName($)?"Not original enough, try again.":null];
  
  EndpointDetails.created() : super.created();
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
}
