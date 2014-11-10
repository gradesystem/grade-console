part of endpoints;

@CustomTag("endpoint-details") 
class EndpointDetails extends PolymerElement with Filters {
  
  
  List<String> fields = [Endpoint.name_field,
                         Endpoint.uri_field];
  
  static List<String> required_fields = [
                         Endpoint.name_field,
                         Endpoint.uri_field];
  
  
  Map<String,List<Validator>> validators = {};
  
  static List<String> area_fields = [];
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  @published
  Endpoints items;
  
  EndpointDetails.created() : super.created() {
    validators[
       Endpoint.name_field]=[($) => items.containsName($)?"Not original enough, try again.":null];
  }
  
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
  
}
