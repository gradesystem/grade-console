part of datasets;

@CustomTag("datasets-panel") 
class DatasetsPanel extends PolymerElement with Filters {
  
  @published
  SubPageModel<Dataset> model;
  
  DatasetsPanel.created() : super.created();
  
  Datasets get datasets => model.storage;
  
  
  void refresh() {
    model.loadAll();
  }
 
}
