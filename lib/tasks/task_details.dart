part of tasks;

@CustomTag("task-details") 
class TaskDetails extends PolymerElement with Filters {
  
  List<String> fields = [
                                        "http://gradesystem.io/onto#uri",
                                        "http://www.w3.org/2000/01/rdf-schema#label",
                                        "http://gradesystem.io/onto/task.owl#source_graph",
                                        "http://gradesystem.io/onto/task.owl#target_graph",
                                        "http://gradesystem.io/onto/task.owl#operation",
                                        "http://purl.org/dc/terms/creator",
                                        "http://www.w3.org/2004/02/skos/core#editorialNote",
                                        "http://gradesystem.io/onto/task.owl#source_endpoint",
                                        "http://gradesystem.io/onto/task.owl#publication_endpoint",
                                        "http://gradesystem.io/onto/task.owl#query"
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
  
  bool isAreaField(String key) {
    return AREA_FIELDS.contains(key);
  }
  
}