part of datasets;

@CustomTag("dataset-details") 
class DatasetDetails extends PolymerElement with Filters {
  
  @published
  Dataset item;
  
  DatasetDetails.created() : super.created();
  
}