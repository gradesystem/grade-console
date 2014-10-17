part of tasks;

class Task extends Delegate with ListItem {
  
  static final String ID_FIELD = "http://gradesystem.io/onto#id";
  
  static final String LABEL_FIELD = "http://www.w3.org/2000/01/rdf-schema#label";
  static final String SOURCE_GRAPH_FIELD = "http://gradesystem.io/onto/task.owl#source_graph";
  static final String TARGET_GRAPH_FIELD = "http://gradesystem.io/onto/task.owl#target_graph";
  static final String QUERY_FIELD = "http://gradesystem.io/onto/task.owl#query";
  static final String OPERATION_FIELD = "http://gradesystem.io/onto/task.owl#operation";
  static final String CREATOR_FIELD = "http://purl.org/dc/terms/creator";
  static final String NOTE_FIELD = "http://www.w3.org/2004/02/skos/core#editorialNote";

  Task(Map bean) : super(bean);
  

  String get id => get(ID_FIELD);
  
  String get label => get(LABEL_FIELD);
  set label(String label) => set(LABEL_FIELD, label);
  
  String get sourceGraph => get(SOURCE_GRAPH_FIELD);
  String get targetGraph => get(TARGET_GRAPH_FIELD);
  String get query => get(QUERY_FIELD);
  String get operation => get(OPERATION_FIELD);
  String get creator => get(CREATOR_FIELD);
  String get note => get(NOTE_FIELD);
 
  String get title => label;
  String get subTitle => targetGraph;
   
}

@Injectable()
class Tasks extends ListItems<Task> {
}
