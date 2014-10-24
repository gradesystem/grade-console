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
  
  void addQuery() {
    model.addNewQuery();
  }
  
  void onEdit() {
    queries.selected.startEdit();
  }
  
  void onCancel() {
    queries.selected.cancel();
  }
  
  void onSave() {
    model.saveQuery(queries.selected);
  }
}
