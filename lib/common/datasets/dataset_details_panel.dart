part of datasets;

@CustomTag("dataset-details-panel") 
class DatasetDetailsPanel extends PolymerElement with Filters {
  
  @published
  Datasets datasets;
  
  DatasetDetailsPanel.created() : super.created();
 
}
