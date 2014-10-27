part of queries;

@CustomTag("query-playground") 
class QueryPlayground extends PolymerElement with Filters {
  
  @observable
  int resultArea = 0;
  
  @published
  EditableQuery editableQuery;
  
  QueryPlayground.created() : super.created() {

  }
  
  //privately used: this is to support refactoring of vocabulary
  String get name_key => Query.name_field;
  String get expression_key => Query.expression_field;
  
  bool get editable => editableQuery.model.bean[Query.predefined_field]==true;
  
  @ComputedProperty("editableQuery.model.bean[name_key]")  
  String get title => "${readValue(#title)}  query playground";
  
  
  void onBack() {
    fire("back");
  }
  
  void onRun() {
    fire("run", detail:editableQuery);
  }
  
}
