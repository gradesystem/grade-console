part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  
  List<String> fields = [Query.name_field,
                         Query.note_field,
                         //Query.target_field, 
                         Query.expression_field];
  
  
  static List<String> area_fields = [Query.expression_field,Query.note_field];
  
  @published
  bool editable = false;
  
  @published
  Query item;
  
  QueryDetails.created() : super.created();
  
  bool isAreaField(String key) {
    return area_fields.contains(key);
  }
  
  //used in template to lookup (cannot bind static fields)
  String get endpoint_key => Query.endpoint_field;
  String get parameters_key => Query.parameters_field;
  
  //privately used
  String get expression_key => Query.expression_field;
  
  @ComputedProperty("item.bean[expression_key]") 
  String get endpoint => item==null ? '...?' : item.endpoint;
 
  @ComputedProperty("item.bean[expression_key]")
  String get parameters {
    
    String params = '(none)';
    
    if (item!=null) {
      
      List<String> parameters = item.parameters;
      params = parameters.isEmpty? params :parameters.toString();
    
    }
    
    return params;
    
  }
  
  String get datasets_key => Query.datasets_field;
  
  
  @ComputedProperty("item.bean[datasets_key]")
  String get datasets {
    
     String sets = '(all)';
     
     if (item!=null) {
     
       List<String> datasets = item.bean[Query.datasets_field];
       
       sets = datasets.isEmpty? sets : datasets.toString();
            
     }
     else {

       print("here but null");
       
     }
     
      return sets;
  }
}