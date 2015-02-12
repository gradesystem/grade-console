part of endpoints;

@CustomTag("endpoint-graphs") 
class EndpointGraphs extends PolymerElement with Filters {
  
  Comparator<Graph> graphSorter = compareGraphs;
  
  @published
  String kfilter;
  
  FilterFunction itemFilter = (Graph item, String term) 
                    => item.label != null && 
                       item.label.toLowerCase().contains(term.toLowerCase());
  
  @published
  Endpoints items;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  EndpointGraphs.created() : super.created();

  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;

}
