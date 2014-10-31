part of queries;

@CustomTag("query-details-summary") 
class QueryDetailsSummary extends PolymerElement with Filters {
   
  @published
  EditableQuery item;
  
  @published
  bool selected;
  
  QueryDetailsSummary.created() : super.created();
  
  
  //privately used: this is to support refactoring of vocabulary
  String get name_key => Query.name_field;
  
  bool get predefined => item.model.bean[Query.predefined_field]==true;
  
  @ComputedProperty("item.model.bean[name_key]")  
  String get name => readValue(#name);

  String get datasets_key => Query.datasets_field;
    
  @ComputedProperty("item.model.bean[datasets_key]")
  String get datasets {
      
       String sets = '(all)';
       
       if (item!=null) {
       
         String datasets = item.model.get(Query.datasets_field);
         
         sets = (datasets==null || datasets.length==0) ? sets : datasets;
              
       }
       
        return sets;
    }
  
  void removeItem() {
    fire("remove-item", detail:item);
  }
  
  void cloneItem() {
    fire("clone-item", detail:item);
  }
  
}
