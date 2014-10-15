part of datasets;

class Dataset extends Delegate with ListItem {

  Dataset(Map bean) : super(bean);
  
   static final String id = "http://gradesystem.io/onto#/id";
   static final List<String> labels = [
                                       "label",
                                       "http://www.w3.org/2000/01/rdf-schema#label",
                                       "http://purl.org/dc/terms/title"
                                      ];
   
   static final List<String> dates = [
                                      "date",
                                      "http://purl.org/dc/terms/date"
                                      ];
  
  String get label {
                    
      for (String lbl in labels) {
         String label = get(lbl);
         if (label!=null)
           return label;
      }

      return get(id);
   }
  
  String get date {
    
    for (String lbl in dates) {
       String label = get(lbl);
          if (label!=null)
             return label;
    }

    return "";
    
  }
   
}


class ListItem {
 
  bool selected;
  
  dynamic get self => this;
}


abstract class Datasets extends Observable {
  
  @observable
  Dataset selected = null;
  
  @observable
  ObservableList<Dataset> data = new ObservableList();
  
  @observable
  bool loading = false;
}

