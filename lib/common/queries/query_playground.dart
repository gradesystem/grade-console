part of queries;

@CustomTag("query-playground") 
class QueryPlayground extends PolymerElement with Filters {
  
  int WHITE_PANEL = 0;
  int ERROR_PANEL = 1;
  int TABS_PANEL = 2;

  QueryKeys K = const QueryKeys();
  
  @observable
  int resultArea = 0;
  
  @observable
  int resultTab = 0;
  
  @published
  EditableQuery editableQuery;
  
  @published
  List<EditableEndpoint> endpoints;
  
  @observable
  bool isactive;
  
  @published
  bool statusEditEnabled = true;
  
  CodemirrorInput expressionEditor;
  
  QueryPlayground.created() : super.created();
  
  void ready() {
    expressionEditor = $["expressionEditor"];
  }
  
  void attributeChanged(name, oldValue, newValue) {
     super.attributeChanged(name, oldValue, newValue);
     if (name == "active") isactive =  attributes.containsKey('active');
   }
  
  @ComputedProperty("editableQuery.model.bean[K.expression]") 
  String get expression => editableQuery!=null?editableQuery.get(K.expression):"";
  void set expression(String exp) {if (editableQuery!=null) editableQuery.set(K.expression, exp);}
  
  @ComputedProperty("editableQuery.model.isSystem") 
  bool get editable => editableQuery!=null?!editableQuery.model.isSystem:false;
  
  @ComputedProperty("editableQuery.model.name")  
  String get paneltitle => editableQuery!=null?(editableQuery.model.name == null || editableQuery.model.name.isEmpty?"(name?)":editableQuery.model.name):"";
  
  @ComputedProperty("editableQuery.lastError")
  String get errorMessage {
  
    return editableQuery!=null && editableQuery.lastError != null && editableQuery.lastError.isClientError()?
                      "Uhm, may be this query is broken? Make sure it's a well-formed SELECT, CONSTRUCT, or DESCRIBE.":
                      "Ouch. Something went horribly wrong...";
  
  }
  
  @ComputedProperty("editableQuery.synching")
  bool get loading => editableQuery!=null && editableQuery.synching;
  
  @ComputedProperty("resultArea == TABS_PANEL")
  bool get showTabs => readValue(#showTabs, ()=>false);
  
  @ObserveProperty("editableQuery editableQuery.lastError editableQuery.lastResult.value")
  void updateResultArea() {
    resultArea = WHITE_PANEL;
    
    if (editableQuery != null) {
      if (editableQuery.lastError!=null) resultArea = ERROR_PANEL;
      if (editableQuery.lastResult.hasValue) resultArea = TABS_PANEL;
    }
  }
  
  void onBack() {
    fire("back");
  }
  
  void onRun() {
    fire("run", detail:editableQuery);
    resultTab = 0;
  }
  
  void onEdit() {
    editableQuery.startEdit();
  }
  
  void onCancel() {
    fire("cancel-editing");
  }

  void onSave() {
    fire("save");
  }
  
  void onEatCrumb(event, detail, target) {
    event.stopImmediatePropagation();
    fire("eat-crumb", detail:{"crumb":detail, "query":editableQuery});
  }
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
  }
  
  void onResultContentCopy(event, detail, target) {
    if (editableQuery.edit) expressionEditor.paste(detail);
  }
  
  void onLoadRawResult(event, detail, target) {
    event.stopImmediatePropagation();
    fire("load-raw", detail:{"query":editableQuery, "format":detail});
  }
  
}
