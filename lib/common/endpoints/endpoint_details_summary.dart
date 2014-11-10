part of endpoints;

@CustomTag("endpoint-details-summary") 
class EndpointDetailsSummary extends PolymerElement with Filters {
   
  @published
  EditableEndpoint item;
  
  @published
  bool selected;
  
  EndpointDetailsSummary.created() : super.created();

  bool get predefined => item.model.bean[Endpoint.predefined_field]==true;

  String get name_key => Endpoint.name_field;
  
  @ComputedProperty("item.model.bean[name_key]")
  String get name {
  
    String name = "(name?)";
    
    if (item!=null) {
      
      String current_name= item.model.get(name_key);
      
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
