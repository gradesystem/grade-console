part of queries;

@CustomTag("query-playground") 
class QueryPlayground extends PolymerElement with Filters {
  
  @observable
  int resultArea = 0;
  
  @published
  EditableQuery editableQuery;
  
  QueryPlayground.created() : super.created();
  
  //privately used: this is to support refactoring of vocabulary
  String get expression_key => Query.expression_field;
  String get predefined_key => Query.predefined_field;
  
  
  @ComputedProperty("editableQuery.model.bean[predefined_key]") 
  bool get editable => editableQuery!=null?editableQuery.model.bean[Query.predefined_field]==false:false;
  
  @ComputedProperty("editableQuery.model.name")  
  String get title => editableQuery!=null?editableQuery.model.name:"";
  
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
