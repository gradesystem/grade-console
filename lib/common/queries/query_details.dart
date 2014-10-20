part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  @published
  Query item;
  
  QueryDetails.created() : super.created();
  
}