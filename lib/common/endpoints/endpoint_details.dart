part of endpoints;

@CustomTag("endpoint-details") 
class EndpointDetails extends PolymerElement with Filters, Validators {
  
  EndpointKeys K = const EndpointKeys();
  
  @published
  Endpoints items;
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  List<Validator> get name_validators => [($) => $!=null && items.containsName($)?"Not original enough, try again.":null];
  
  EndpointDetails.created() : super.created();
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
}
