part of endpoints;

@CustomTag("endpoint-graphs") 
class EndpointGraphs extends PolymerElement with Filters {
  
  Comparator<Graph> graphSorter = compareGraphs;
  
  @published
  String kfilter;
  
  filter(String term) {
     return (List items) => items == null || items.isEmpty || term == null || term.isEmpty ? items : 
       toObservable(items.where((Graph item) 
           => item.label != null && 
              item.label.toLowerCase().contains(term.toLowerCase())).toList()); 
   }
  
  @published
  Endpoints items;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  EndpointGraphs.created() : super.created();

  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;

}
