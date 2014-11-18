part of datasets;

class Dataset extends Delegate with Observable {

  Dataset(Map bean) : super(bean);
  
   static final String id = "http://gradesystem.io/onto#uri";
   static final List<String> labels = [
                                       "label",
                                       "http://www.w3.org/2000/01/rdf-schema#label",
                                       "http://purl.org/dc/terms/title"
                                      ];
   
   static final List<String> dates = [
                                      "date",
                                      "http://purl.org/dc/terms/date"
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
    
    for (String lbl in dates) {
       String label = get(lbl);
          if (label!=null)
             return label;
    }

    return "";
    
  }
   
}


abstract class Datasets extends ListItems<Dataset> {
}

