part of graphs;

@CustomTag("graphs-panel") 
class GraphsPanel extends PolymerElement with Filters {
  
  @observable
  String kfilter='';
  
  @published
  String title;
  
  @published
  Graphs graphs;
  
  GraphsPanel.created() : super.created();
  
  void refresh() {
    fire("refresh");
  }
  
}