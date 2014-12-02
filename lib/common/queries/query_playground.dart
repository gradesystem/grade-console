part of queries;

@CustomTag("query-playground") 
class QueryPlayground extends PolymerElement with Filters {

  QueryKeys K = const QueryKeys();
  
  @observable
  int resultArea = 0;
  
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
  
  String errorMessage()   {
  
    return editableQuery.lastError.isClientError()?
                      "Uhm, may be this query is broken? Make sure it's a well-formed SELECT, CONSTRUCT, or DESCRIBE.":
                      "Ouch. Something went horribly wrong...";
  
  }
  
  void onBack() {
    fire("back");
  }
  
  void onRun() {
    fire("run", detail:editableQuery);
  }
  
  void showErrorDetails() {
    CoreCollapse collapse = $["errorDetails"] as CoreCollapse;
    collapse.toggle();
  }
  
}
