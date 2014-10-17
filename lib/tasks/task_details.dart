part of tasks;

@CustomTag("task-details") 
class TaskDetails extends PolymerElement with Filters {
  
  static List<String> ORDERED_FIELDS = [
                                        "http://gradesystem.io/onto#id",
                                        "http://www.w3.org/2000/01/rdf-schema#label",
                                        "http://gradesystem.io/onto/task.owl#source_graph",
                                        "http://gradesystem.io/onto/task.owl#target_graph",
                                        "http://gradesystem.io/onto/task.owl#query",
                                        "http://gradesystem.io/onto/task.owl#operation",
                                        "http://purl.org/dc/terms/creator",
                                        "http://www.w3.org/2004/02/skos/core#editorialNote"
                                        
                                        ];
  
  static List<String> AREA_FIELDS = [
                                          "http://gradesystem.io/onto/task.owl#query",
                                                 "http://www.w3.org/2004/02/skos/core#editorialNote"
                                          
                                          ];
    
  @published
  bool editable = false;
  
  @published
  String test;
  
  @published
  Task item;
  
  TaskDetails.created() : super.created();
  
  List<String> get orderedFields => ORDERED_FIELDS;
  
  bool isAreaField(String key) {
    return AREA_FIELDS.contains(key);
  }
  
}