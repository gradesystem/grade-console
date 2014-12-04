part of datasets;

@CustomTag("datasets-panel") 
class DatasetsPanel extends PolymerElement with Filters, Dependencies {
  
  @observable
  String kfilter='';

  @published
  String page;
  
  DatasetsPageModel model;
  
  DatasetsPanel.created() : super.created() {
    if (page == null) throw new Exception("Page attribute not specified");
    
    Type pageAnnotation = typeCalled(page);
    model = instanceOf(DatasetsPageModel, pageAnnotation);
  }
  
  Datasets get datasets => model.storage;
  
  void refresh() {
    model.loadAll();
  }
 
}
