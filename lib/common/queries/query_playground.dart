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
  
  void onBack() {
    fire("back");
  }
  
  void onRun() {
    fire("run", detail:editableQuery);
  }
  
}
