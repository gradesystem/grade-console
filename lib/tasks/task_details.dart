part of tasks;

@CustomTag("task-details") 
class TaskDetails extends PolymerElement with Filters {
  
  static List<String> ORDERED_FIELDS = [
                                        "http://www.w3.org/2000/01/rdf-schema#label",
                                        "http://semanticrepository/publisher/task#source_graph",
                                        "http://semanticrepository/publisher/task#target_graph",
                                        "http://semanticrepository/publisher/task#query",
                                        "http://semanticrepository/publisher/task#operation",
                                        "http://purl.org/dc/terms/creator",
                                        "http://www.w3.org/2004/02/skos/core#editorialNote"
                                        
                                        ];
  
  
  
  @published
  Task item;
  
  TaskDetails.created() : super.created();
  
  List<String> get orderedFields => ORDERED_FIELDS;
  
}