part of queries;

@CustomTag("query-details-summary") 
class QueryDetailsSummary extends PolymerElement with Filters {
   
  @published
  Query item;
  
  @published
  bool selected;
  
  QueryDetailsSummary.created() : super.created();
  
  
  //privately used: this is to support refactoring of vocabulary
  String get name_key => Query.name_field;
  String get expression_key => Query.expression_field;
 
  bool get predefined => item.bean[Query.predefined_field]==true;
  
  @ComputedProperty("item.bean[name_key]")  
  String get name => readValue(#name);
  
  @ComputedProperty("item.bean[expression_key]") 
  String get endpoint => item==null ? '...?' : item.endpoint;
  
}