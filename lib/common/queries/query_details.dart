part of queries;

@CustomTag("query-details") 
class QueryDetails extends PolymerElement with Filters {
  
  static List<String> AREA_FIELDS = [
                                      "http://gradesystem.io/onto/query.owl#expression",
                                      "http://gradesystem.io/onto/query.owl#note"
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