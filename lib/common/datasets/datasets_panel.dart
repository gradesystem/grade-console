part of datasets;

@CustomTag("datasets-panel") 
class DatasetsPanel extends PolymerElement with Filters {
  
  @observable
  String kfilter='';
  
  @published
  String title;
  
  @published
  Datasets datasets;
  
  DatasetsPanel.created() : super.created();
  
  void refresh() {
    fire("refresh");
  }
  
}