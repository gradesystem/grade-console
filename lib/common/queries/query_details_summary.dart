part of queries;

@CustomTag("query-details-summary") 
class QueryDetailsSummary extends PolymerElement with Filters {
   
  @published
  EditableQuery item;
  
  @published
  bool selected;
  
  QueryDetailsSummary.created() : super.created();

  bool get predefined => item.model.bean[Query.predefined_field]==true;

  String get datasets_key => Query.datasets_field;
  String get name_key => Query.name_field;
  
  @ComputedProperty("item.model.bean[name_key]")
  String get name {
  
    String name = "(name?)";
    
    if (item!=null) {
      
      String current_name= item.model.get(name_key);
      
      name = (current_name==null || current_name.isEmpty)? name : current_name;
      
    }
    
    return name;
      
  }
  
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
