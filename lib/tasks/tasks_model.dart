part of tasks;

class Task extends Delegate with ListItem {

  Task(Map bean) : super(bean);
  
   static final String id = "http://gradesystem.io/onto#id";
   static final List<String> labels = [
                                       "http://www.w3.org/2000/01/rdf-schema#label"
                                      ];
   
   static final List<String> subtitles = [
                                      "http://semanticrepository/publisher/task#target_graph"
                                      ];
  
  String get title {
                    
      for (String lbl in labels) {
         String label = get(lbl);
         if (label!=null)
           return label;
      }

      return get(id);
   }
  
  String get subTitle {
    
    for (String lbl in subtitles) {
       String label = get(lbl);
          if (label!=null)
             return label;
    }

    return "";
    
  }
   
}

@Injectable()
class Tasks extends ListItems<Task> {
}
