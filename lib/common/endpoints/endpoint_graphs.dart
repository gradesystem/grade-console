part of endpoints;

@CustomTag("endpoint-graphs") 
class EndpointGraphs extends PolymerElement with Filters {
  
  @published
  Endpoints items;
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  String get graphs_key =>  Endpoint.graphs_field;
  
  @observable
  bool newUrlInvalid;
  
  @observable
  String newUrl = "";
  
  EndpointGraphs.created() : super.created();
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  void refreshGraphs() {
    fire("refresh-graphs", detail:item);
  }
  
  void addGraph() {
    fire("add-graph", detail:newUrl);
    newUrl = "";
  }
  
  void removeGraph(event, detail, target) {
    fire("remove-graph", detail:target.attributes['graph']);
  }
}
