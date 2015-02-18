part of queries;

@CustomTag("queries-panel")
class QueriesPanel extends ResizerPolymerElement with Filters, Dependencies {

  @published
  String page;
  
  @observable
  int subArea = 0;
  
  @published
  bool statusEditEnabled = true;
  
  @published
  String paneltitle = "QUERIES";

  QueryKeys K = const QueryKeys();
  
  @observable
  ObservableList<ListFilter> filters;

  @observable
  int area = 0;

  @published
  String kfilter = '';

  @observable
  bool removeDialogOpened = false;

  @observable
  String removedDialogHeader;
  
  @observable
  bool saveDialogOpened = false;

  @observable
  String saveDialogHeader;
  
  Function dialogCallback;

  QuerySubPageModel model;

  Endpoints endpoints;

  Refresh endpointRefresh;

  PaperTabs propertiesTabs;

  QueriesPanel.created() : super.created() {
    if (page == null) throw new Exception("Page attribute not specified");

    Type pageAnnotation = typeCalled(page);
    model = instanceOf(QuerySubPageModel, pageAnnotation);
    endpoints = instanceOf(Endpoints, pageAnnotation);
    endpointRefresh = (instanceOf(EndpointSubPageModel, pageAnnotation) as EndpointSubPageModel).refreshGraphs;

  }
  
  void ready() {
    propertiesTabs = $["propertiesTabs"] as PaperTabs;
    addResizeListener((_)=>propertiesTabs.updateBar());
  }

  Queries get queries => model.storage;

  void refresh() {
    model.loadAll();
  }

  void addQuery() {
    model.addNew();
  }

  void onEdit() {
    queries.selected.startEdit();
  }

  void onCancel() {
    model.cancelEditing(queries.selected);
  }

  void onSave() {
    
    EditableQuery query = queries.selected;
    
    if (query.model.status != K.status_unpublished && !query.newModel && query.model.endpoint != query.original.endpoint) _requestSaveConfirm(query);
    else model.save(queries.selected);
  }
  
  void _requestSaveConfirm(EditableQuery query) {
    saveDialogHeader = "Save ${query.model.name}";
    saveDialogOpened = true;
    dialogCallback = ()=>model.save(query);
  }

  void onQueryPlayground() {
    area = 1;
  }

  void onBack() {
    area = 0;
  }

  void onRunQuery(event, detail, target) {
    model.runQuery(detail["query"], detail["limit"]);
  }
  
  void onEatCrumb(event, detail, target) {
    model.eatCrumb(detail["query"], detail["crumb"], detail["limit"]);
  }
  
  void onLoadRaw(event, detail, target) {
    model.loadRaw(detail["query"], detail["limit"], detail["format"]);
  }

  void removeItem(event, detail, target) {
    Query query = detail.model;
    removedDialogHeader = "Remove ${query.bean[K.name]}";
    removeDialogOpened = true;
    dialogCallback = ()=>model.remove(detail);
  }

  void dialogAffermative() {
    if (dialogCallback != null) dialogCallback();
  }

  void cloneItem(event, detail, target) {
    model.clone(detail);
  }
  
}
