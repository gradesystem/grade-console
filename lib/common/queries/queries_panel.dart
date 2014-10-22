part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  bool editable = false;
  
  @published
  SubPageModel<Query> model;

  QueriesPanel.created() : super.created();
  
  Queries get queries => model.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void onEdit() {
    editable = !editable;
  }
 
}
