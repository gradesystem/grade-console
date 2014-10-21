part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @published
  SubPageModel<Query> model;

  
  QueriesPanel.created() : super.created();
  
  Queries get queries => model.storage;
  
  void refresh() {
    model.loadAll();
  }
 
}
