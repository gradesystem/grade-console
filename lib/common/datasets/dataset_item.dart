part of datasets;

@CustomTag("dataset-item") 
class DatasetItem extends PolymerElement with Filters {
  
  @published
  Dataset item;
  
  DatasetItem.created() : super.created();
  
}