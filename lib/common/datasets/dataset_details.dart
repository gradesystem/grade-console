part of datasets;

@CustomTag("dataset-details") 
class DatasetDetails extends PolymerElement with Filters {
  
  List<String> dateFields = [Dataset.CREATION_DATE_FIELD]; 
  
  @published
  Dataset item;
  
  DatasetDetails.created() : super.created();
  
  String getValue(String key) => isDate(key)?formatDate(item.getDate(key)):trim(item.get(key));
  
  bool isDate(String key) => key!=null && dateFields.contains(key);

  
  
}