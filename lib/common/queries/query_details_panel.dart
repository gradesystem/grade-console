part of queries;

@CustomTag("query-details-panel") 
class QueryDetailsPanel extends PolymerElement with Filters {
  
  @published
  Queries queries;

  @published
  bool editable = false;
  
  QueryDetailsPanel.created() : super.created();
  
  void onEdit() {
    editable = !editable;
  }
 
}
