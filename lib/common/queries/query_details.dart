part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  
  List<String> fields = [Query.name_field,
                         Query.datasets_field,
                         Query.note_field,
                         //Query.target_field, 
                         Query.expression_field];
  
  
  static List<String> area_fields = [Query.expression_field,Query.note_field];
  
  @published
  bool editable = false;
  
  @published
  EditableModel<Query> item;
  
  QueryDetails.created() : super.created();
  
  bool isAreaField(String key) {
    return area_fields.contains(key);
  }
  
  //used in template to lookup (cannot bind static fields)
  String get endpoint_key => Query.endpoint_field;
  String get parameters_key => Query.parameters_field;
  
  //privately used
  String get expression_key => Query.expression_field;
  
  @ComputedProperty("item.model.bean[expression_key]") 
  String get endpoint => item==null ? '...?' : item.model.endpoint;
 
  @ComputedProperty("item.model.bean[expression_key]")
  String get parameters {
    
    String params = '(none)';
    
    if (item!=null) {
      
      List<String> parameters = item.model.parameters;
      params = parameters.isEmpty? params :parameters.toString();
    
    }
    
    return params;
    
  }
  
}
