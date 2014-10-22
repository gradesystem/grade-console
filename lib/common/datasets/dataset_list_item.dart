part of datasets;

@CustomTag("dataset-list-item") 
class DatasetListItem extends PolymerElement with Filters {
  
  @published
  ListItem item;
  
  DatasetListItem.created() : super.created();
  
}