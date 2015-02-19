part of datasets;

@CustomTag("dataset-details") 
class DatasetDetails extends PolymerElement with Filters {
  
  List<String> dateFields = [Dataset.CREATION_DATE_FIELD, Dataset.MODIFIED_DATE_FIELD]; 
  
  @published
  Dataset item;
  
  DatasetDetails.created() : super.created();
  
  //we pass value in order to trigger the change in the view
  String getValue(String key, value) => isDate(key)?item.extractAndFormatDate(key):trim(value);
  
  bool isDate(String key) => key!=null && dateFields.contains(key);
  
}