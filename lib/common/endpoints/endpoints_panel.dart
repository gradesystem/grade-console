part of endpoints;

@CustomTag("endpoints-panel") 
class EndpointsPanel extends PolymerElement with Filters {
  
  @observable
  int area = 0;
  
  @published
  String kfilter = '';

  @published
  EndpointSubPageModel model;
  
  @observable
  bool removeDialogOpened = false;
  
  @observable
  String removedDialogHeader;
  
  EditableEndpoint deleteCandidate;
  
  EndpointsPanel.created() : super.created();
  
  Endpoints get items => model.storage;
  
  @ObserveProperty("model.storage.selected")
  void updateArea() {
    if (model!=null && model.storage.selected!=null && model.storage.selected.newModel) area = 0; 
  }
  
  void refresh() {
    model.loadAll();
  }
  
  void addEndpoint() {
    model.addNewEndpoint();
  }
  
  void onEdit() {
    items.selected.startEdit();
  }
  
  void onCancel() {
    model.cancelEditing(items.selected);
  }
  
  void onSave() {
    model.saveEndpoint(items.selected);
  }
  
  void removeItem(event, detail, target) {
    deleteCandidate = detail;
    Endpoint query = deleteCandidate.model;
    removedDialogHeader = "Remove ${query.bean[Endpoint.name_field]}";
    removeDialogOpened = true;
  }
  
  void deleteSelectedItem() {
    if (deleteCandidate!=null) model.removeEndpoint(deleteCandidate);
  }
  
  void cloneItem(event, detail, target) {
    model.cloneEndpoint(detail);
  }
  
  void onRefreshGraphs(event, detail, target) {
    model.refreshGraphs(detail);
  }
}
