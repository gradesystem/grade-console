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
  List<String> url_fields = [Endpoint.uri_field];
  
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
  
  String fieldType(String key) {
    return url_fields.contains(key)?"URL":null;
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
