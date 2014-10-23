part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @published
  String kfilter = '';

  
  
  @published
  bool edit = false;
  
  @published
  SubPageModel<Query> model;

  QueriesPanel.created() : super.created();
  
  Queries get queries => model.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void onEdit() {
   // log.info("onEdit");
    edit = true;
  }
  
  void onCancel() {
   // log.info("onCancel");
    edit = false;
  }
  
  void onSave() {
   // log.info("onSave");
    edit = false;
  }
 
}
