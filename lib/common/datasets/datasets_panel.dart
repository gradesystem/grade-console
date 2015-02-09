part of datasets;

@CustomTag("datasets-panel") 
class DatasetsPanel extends ResizerPolymerElement with Filters, Dependencies {
  
  @observable
  String kfilter='';

  @published
  String page;
  
  @published
  bool uploadEnabled = false;
  
  DatasetsPageModel model;
  EndpointSubPageModel endpointsModel;
  
  DatasetUploadDialog uploadDialog;

  DatasetsPanel.created() : super.created() {
    if (page == null) throw new Exception("Page attribute not specified");
    
    Type pageAnnotation = typeCalled(page);
    model = instanceOf(DatasetsPageModel, pageAnnotation);
    endpointsModel = instanceOf(EndpointSubPageModel, pageAnnotation);
  }
  
  void ready() {
    uploadDialog = $["uploadDialog"];
  }
  
  Datasets get datasets => model.storage;
  ListItems get endpoints => endpointsModel.storage;
  
  void refresh() {
    model.loadAll();
  }
  
  void upload() {
    uploadDialog.open();
  }
  
  void onFileDrop(event, detail, target) {
    uploadDialog.openWithFile(detail);
  }
 
}
