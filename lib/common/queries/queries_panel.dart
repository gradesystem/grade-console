part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @published
  String kfilter = '';

  
  @published
  QuerySubPageModel model;

  QueriesPanel.created() : super.created();
  
  Queries get queries => model.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  
  
  void onEdit() {
   // log.info("onEdit");
    queries.selected.startEdit();
  }
  
  void onCancel() {
   // log.info("onCancel");
    queries.selected.cancel();
  }
  
  void onSave() {
   // log.info("onSave");
    queries.selected.save();
  }
  
  void onDump() {
    queries.selected.dump();
  }
 
}
