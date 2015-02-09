part of endpoints;

@CustomTag("endpoint-graphs") 
class EndpointGraphs extends PolymerElement with Filters {
  
  GraphKeys K = new GraphKeys();
  
  Comparator<Graph> graphSorter = compareGraphs;
  
  @observable
  String kfilter;
  
  FilterFunction itemFilter = (Graph item, String term) 
                    => item.label != null && 
                       item.label.toLowerCase().contains(term.toLowerCase());
  
  @published
  Endpoints items;
  
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('items.selected')
  EditableEndpoint get item => items==null?null:items.selected;
  
  GraphDialog graphDialog;
  
  EndpointGraphs.created() : super.created();
  
  void ready() {
    graphDialog = $["graphDialog"];
  }
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  void refreshGraphs() {
    fire("refresh-graphs", detail:item);
  }
  
  void addGraph() {
    graphDialog.openAdd();
  }
  
  void editGraph(event,detail,target) {
    graphDialog.openEdit(detail);
  }
  
  void moveGraph(event,detail,target) {
    graphDialog.openMove(detail, item);
  }
  
  void removeGraph(event, detail, target) {
    fire("remove-graph", detail:target.attributes['graph']);
  }
}
