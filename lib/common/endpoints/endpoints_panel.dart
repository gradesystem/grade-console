part of endpoints;

@CustomTag("endpoints-panel") 
class EndpointsPanel extends PolymerElement with Filters, Dependencies {

  @published
  EndpointSubPageModel model;
  
  @published
  String page;
    
  @observable
  int area = 0;
  
  @observable
  String kfilter = '';
  
  @observable
  bool removeDialogOpened = false;
  
  @observable
  String removedDialogHeader;
  
  Function dialogCallback;
  
  EndpointsPanel.created() : super.created() {
    if (page!=null) {
      Type pageAnnotation = typeCalled(page);
      model = instanceOf(EndpointSubPageModel, pageAnnotation);
    }
  }
  
  Endpoints get items => model.storage;
  
  @ObserveProperty("model.storage.selected")
  void updateArea() {
    if (model!=null && model.storage.selected!=null && model.storage.selected.newModel) area = 0; 
  }
  
  void refresh() {
    model.loadAll();
  }
  
  void addEndpoint() {
    model.addNew();
  }
  
  void onEdit() {
    items.selected.startEdit();
  }
  
  void onCancel() {
    model.cancelEditing(items.selected);
  }
  
  void onSave() {
    model.save(items.selected);
  }
  
  void dialogAffermative() {
    if (dialogCallback!=null) dialogCallback();
  }
  
  void removeItem(event, detail, target) {
    EditableEndpoint deleteCandidate = detail;
    dialogCallback = (){model.remove(deleteCandidate);};
    Endpoint query = deleteCandidate.model;
    removedDialogHeader = "Remove ${query.bean[Endpoint.K.name]}";
    removeDialogOpened = true;
  }
  
  void cloneItem(event, detail, target) {
    model.clone(detail);
  }
  
  void onRefreshGraphs(event, detail, target) {
    model.refreshGraphs(detail);
  }
  
  void onRemoveGraph(event, detail, target) {
    dialogCallback = (){model.removeEndpointGraph(items.selected, detail);};
    removedDialogHeader = "Remove ${detail.label}";
    removeDialogOpened = true;
  }
  
  void onAddGraph(event, detail, target) {
    model.addEndpointGraph(items.selected, detail);
  }
}
