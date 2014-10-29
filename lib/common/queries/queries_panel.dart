part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @observable
  int area = 0;
  
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
  
  void onQueryPlayground() {
    area = 1;
  }
  
  void onBack() {
    area = 0;
  }
  
  void onRunQuery(event, detail, target) {
    model.runQuery(detail);
  }
}
