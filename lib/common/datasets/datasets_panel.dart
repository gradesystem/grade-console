part of datasets;

@CustomTag("datasets-panel") 
class DatasetsPanel extends ResizerPolymerElement with Filters, Dependencies {
  
  @observable
  String kfilter='';

  @published
  String page;
  
  @published
  bool uploadEnabled = false;
  
  @observable
  bool uploadDialogOpened = false;
  
  DatasetsPageModel model;
  EndpointSubPageModel endpointsModel;

  DatasetsPanel.created() : super.created() {
    if (page == null) throw new Exception("Page attribute not specified");
    
    Type pageAnnotation = typeCalled(page);
    model = instanceOf(DatasetsPageModel, pageAnnotation);
    endpointsModel = instanceOf(EndpointSubPageModel, pageAnnotation);
  }
  
  Datasets get datasets => model.storage;
  ListItems get endpoints => endpointsModel.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void upload() {
    uploadDialogOpened = true;
  }
 
}
