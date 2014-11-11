part of queries;

@CustomTag("query-playground") 
class QueryPlayground extends PolymerElement with Filters {
  
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
  
  //privately used: this is to support refactoring of vocabulary
  String get expression_key => Query.expression_field;
  String get predefined_key => Query.predefined_field;
  String get target_key => Query.target_field;
  
  @ComputedProperty("editableQuery.model.bean[expression_key]") 
  String get expression => editableQuery!=null?editableQuery.model.bean[Query.expression_field]:"";
  void set expression(String exp) {editableQuery.model.bean[Query.expression_field] = exp;}
  
  
  @ComputedProperty("editableQuery.model.bean[predefined_key]") 
  bool get editable => editableQuery!=null?editableQuery.model.bean[Query.predefined_field]==false:false;
  
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
    //($["detailsbutton"] as Element).text = collapse.opened?"Hide details":"Show details";
  }
  
}
