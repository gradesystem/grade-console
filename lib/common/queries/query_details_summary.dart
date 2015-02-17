part of queries;

@CustomTag("query-details-summary") 
class QueryDetailsSummary extends PolymerElement with Filters {
  
  QueryKeys K = const QueryKeys();
   
  @published
  EditableQuery item;
  
  @published
  bool selected;
  
  QueryDetailsSummary.created() : super.created();
  
  @ComputedProperty("item.model.bean[K.name]")
  String get name {
  
    String name = "(name?)";
    
    if (item!=null) {
      
      String current_name= item.get(K.name);
      
      name = (current_name==null || current_name.isEmpty)? name : current_name;
      
    }
    
    return name;
      
  }
  
  void removeItem(event) {
    event.stopImmediatePropagation();
    fire("remove-item", detail:item);
  }
  
  void cloneItem(event) {
    event.stopImmediatePropagation();
    fire("clone-item", detail:item);
  }
  
}
