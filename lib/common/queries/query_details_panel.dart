part of queries;

@CustomTag("query-details-panel") 
class QueryDetailsPanel extends PolymerElement with Filters {
  
  @published
  Queries queries;
  
  QueryDetailsPanel.created() : super.created();
 
}
