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
  EditableModel<Query> item;
  
  QueryDetails.created() : super.created();
  
  bool isAreaField(String key) {
    return area_fields.contains(key);
  }
  
  String get endpoint_name => Query.endpoint_field;
  
}