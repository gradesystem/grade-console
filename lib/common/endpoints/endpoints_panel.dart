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
  
  Function dialogCallback;
  
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
  
  void dialogAffermative() {
    if (dialogCallback!=null) dialogCallback();
  }
  
  void removeItem(event, detail, target) {
    EditableEndpoint deleteCandidate = detail;
    dialogCallback = (){model.removeEndpoint(deleteCandidate);};
    Endpoint query = deleteCandidate.model;
    removedDialogHeader = "Remove ${query.bean[Endpoint.name_field]}";
    removeDialogOpened = true;
  }
  
  void cloneItem(event, detail, target) {
    model.cloneEndpoint(detail);
  }
  
  void onRefreshGraphs(event, detail, target) {
    model.refreshGraphs(detail);
  }
  
  void onRemoveGraph(event, detail, target) {
    String graph = detail;
    dialogCallback = (){model.removeEndpointGraph(items.selected, graph);};
    removedDialogHeader = "Remove $graph";
    removeDialogOpened = true;
  }
}
