part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  static List<String> AREA_FIELDS = [
                                      "http://gradesystem.io/onto/task.owl#query",
                                      "http://www.w3.org/2004/02/skos/core#editorialNote"
                                    ];
  
  @published
  bool editable = false;
  
  @published
  Query item;
  
  QueryDetails.created() : super.created();
  
  bool isAreaField(String key) {
    return AREA_FIELDS.contains(key);
  }
  
}