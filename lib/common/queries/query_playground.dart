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
  
  @observable
  bool isactive;
  
  QueryPlayground.created() : super.created();
  
  void attributeChanged(name, oldValue, newValue) {
     super.attributeChanged(name, oldValue, newValue);
     if (name == "active") isactive =  attributes.containsKey('active');
   }
  
  @ComputedProperty("editableQuery.model.bean[K.expression]") 
  String get expression => editableQuery!=null?editableQuery.get(K.expression):"";
  void set expression(String exp) {if (editableQuery!=null) editableQuery.set(K.expression, exp);}
  
  @ComputedProperty("editableQuery.model.bean[K.predefined]") 
  bool get editable => editableQuery!=null?editableQuery.model.bean[K.predefined]==false:false;
  
  @ComputedProperty("editableQuery.model.name")  
  String get title => editableQuery!=null?(editableQuery.model.name == null || editableQuery.model.name.isEmpty?"(name?)":editableQuery.model.name):"";
  
  @ComputedProperty("editableQuery.lastError")
  String get errorMessage {
  
    return editableQuery!=null && editableQuery.lastError != null && editableQuery.lastError.isClientError()?
                      "Uhm, may be this query is broken? Make sure it's a well-formed SELECT, CONSTRUCT, or DESCRIBE.":
                      "Ouch. Something went horribly wrong...";
  
  }
  
  @ComputedProperty("resultArea == TABS_PANEL")
  bool get showTabs => readValue(#showTabs, ()=>false);
  
  @ObserveProperty("editableQuery editableQuery.lastError editableQuery.lastQueryResult")
  void updateResultArea() {
    resultArea = WHITE_PANEL;
    
    if (editableQuery != null) {
      if (editableQuery.lastError!=null) resultArea = ERROR_PANEL;
      if (editableQuery.lastQueryResult!=null) resultArea = TABS_PANEL;
    }
  }
  
  void onBack() {
    fire("back");
  }
  
  void onRun() {
    fire("run", detail:editableQuery);
  }
  
  void onResultUriClick(event, detail, target) {
    editableQuery.history.go(detail);
    fire("describe-result", detail:detail);
  }
  
  //remove when breadcumb approved
  void onResultBack() {
    editableQuery.history.goBack();
    if (!editableQuery.history.empty) fire("describe-result", detail:editableQuery.history.currentUri);
    else fire("run", detail:editableQuery);
  }
  
  //remove when breadcumb approved
  void onResultForward() {
    editableQuery.history.goForward();
    fire("describe-result", detail:editableQuery.history.currentUri);
  }
  
  void onResultGoUri(event, detail, target) {
    int index = int.parse(detail);
    editableQuery.history.goIndex(index);
    if (!editableQuery.history.empty) fire("describe-result", detail:editableQuery.history.currentUri);
    else fire("run", detail:editableQuery);
  }
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
  }
  
}
