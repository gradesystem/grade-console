part of endpoints;

@CustomTag("endpoints-panel") 
class EndpointsPanel extends ResizerPolymerElement with Filters, Dependencies {
  
  int GRAPHS_AREA = 0;
  int PROPERTIES_AREA = 1;
  
  @published
  String page;
    
  @observable
  int area = 0;
  
  @observable
  String kfilter = '';
  
  @observable
  ObservableList<ListFilter> filters;
  
  @observable
  String graphkfilter;
  
  GraphDialog graphDialog;
  
  @observable
  bool removeDialogOpened = false;
  
  @observable
  String removedDialogHeader;
  
  @observable
  EndpointSubPageModel model;
  
  Function dialogCallback;
  
  PaperTabs propertiesTabs;
  
  EndpointsPanel.created() : super.created() {
    if (page == null) throw new Exception("Page attribute not specified");
    
    Type pageAnnotation = typeCalled(page);
    model = instanceOf(EndpointSubPageModel, pageAnnotation);
    
    addResizeListener((_)=>propertiesTabs.updateBar());
  }
  
  void ready() {
    propertiesTabs = $["propertiesTabs"] as PaperTabs;
    graphDialog = $["graphDialog"];
  }
  
  Endpoints get items => model.storage;
  
  @ObserveProperty("model.storage.selected")
  void updateArea() {
    if (model!=null && (model.storage.selected!=null && model.storage.selected.newModel) || model.storage.selected == null) {
      area = PROPERTIES_AREA; 
      propertiesTabs.updateBar();
    }
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
    model.refreshGraphs(items.selected);
  }
  
  void onRemoveGraph(event, detail, target) {
    Graph graph = detail as Graph;
    if (graph.size != null && graph.size>0) {
      dialogCallback = (){model.removeEndpointGraph(items.selected, graph);};
      removedDialogHeader = "Remove ${graph.label}";
      removeDialogOpened = true;
    } else {
      model.removeEndpointGraph(items.selected, graph);
    }
  }
  
  void addGraph() {
    graphDialog.openAdd();
  }
  
  void editGraph(event,detail,target) {
    graphDialog.openEdit(detail);
  }
  
  void moveGraph(event,detail,target) {
    graphDialog.openMove(detail, items.selected);
  }
  
  void onAddedGraph(event, detail, target) {
    model.addEndpointGraph(items.selected, detail);
  }
  
  void onEditedGraph(event, detail, target) {
    model.editEndpointGraph(items.selected, detail["old-graph"], detail["new-graph"]);
  }
  
  void onMovedGraph(event, detail, target) {
    model.moveEndpointGraph(items.selected, detail["old-graph"], detail["new-graph"], detail["old-endpoint"], detail["new-endpoint-name"], detail["delete-original"]);
  }

}
