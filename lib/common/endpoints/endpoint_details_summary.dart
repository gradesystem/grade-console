part of endpoints;

@CustomTag("endpoint-details-summary") 
class EndpointDetailsSummary extends PolymerElement with Filters {
  
  EndpointKeys K = const EndpointKeys();
   
  @published
  EditableEndpoint item;
  
  @published
  bool selected;
  
  EndpointDetailsSummary.created() : super.created();
  
  @ComputedProperty("item.model.bean[K.name]")
  String get name {
  
    String name = "(name?)";
    
    if (item!=null) {
      
      String current_name= item.model.get(K.name);
      
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
