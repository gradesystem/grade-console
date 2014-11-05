part of queries;

@CustomTag("queries-panel") 
class QueriesPanel extends PolymerElement with Filters {
  
  @observable
  int area = 0;
  
  @published
  String kfilter = '';

  @published
  QuerySubPageModel model;
  
  @observable
  bool removeDialogOpened = false;
  
  @observable
  String removedDialogHeader;
  
  EditableQuery deleteCandidate;
  

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
    model.cancelEditing(queries.selected);
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

  void removeItem(event, detail, target) {
    deleteCandidate = detail;
    Query query = deleteCandidate.model;
    removedDialogHeader = "Remove ${query.bean[Query.name_field]}";
    removeDialogOpened = true;
  }
  
  void deleteSelectedQuery() {
    if (deleteCandidate!=null) model.removeQuery(deleteCandidate);
  }
  
  void cloneItem(event, detail, target) {
    model.cloneQuery(detail);
  }
}
