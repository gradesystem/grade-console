part of queries;

@CustomTag("query-details-summary") 
class QueryDetailsSummary extends PolymerElement with Filters {
  
  QueryKeys K = const QueryKeys();
   
  @published
  EditableQuery item;
  
  @published
  bool selected;
  
  QueryDetailsSummary.created() : super.created();

  bool get predefined => item.model.bean[K.predefined]==true;
  
  @ComputedProperty("item.model.bean[K.name]")
  String get name {
  
    String name = "(name?)";
    
    if (item!=null) {
      
      String current_name= item.get(K.name);
      
      name = (current_name==null || current_name.isEmpty)? name : current_name;
      
    }
    
    return name;
      
  }
  
  void removeItem() {
    fire("remove-item", detail:item);
  }
  
  void cloneItem() {
    fire("clone-item", detail:item);
  }
  
}
