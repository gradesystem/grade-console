part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  QueryKeys K = const QueryKeys();  
  
  List<String> fields = [Query.K.datasets,
                         Query.K.note,
                         Query.K.expression];
  
  static List<String> required_fields = [
                         Query.K.name,
                         Query.K.target,
                         Query.K.expression];
  
  
  Map<String,List<Validator>> validators = {};
  
  static List<String> area_fields = [Query.K.expression, Query.K.note];
  
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
       Query.K.name]=[($) =>  $!=null && queries.containsName($)?"Not original enough, try again.":null];
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
