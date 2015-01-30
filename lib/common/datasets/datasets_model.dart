part of datasets;

class Dataset extends GradeEntity {

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

int compareDatasets(Dataset d1, Dataset d2) {
  if (d1 == null || d1.title == null) return 1;
  if (d2 == null || d2.title == null) return -1;
  return compareIgnoreCase(d1.title, d2.title);
}


class Datasets extends ListItems<Dataset> {
  Datasets():super(compareDatasets);
}

class DatasetsPageModel extends SubPageModel<Dataset> {
  
  DatasetsPageModel(EventBus bus, ListService<Dataset> service, ListItems<Dataset> storage):super(bus, service, storage);
  
  DatasetService get datasetService => service;
  
  void uploadDataset(String name, String endpoint, MediaType type, File file, [CSVConfiguration csvconfiguration]) {
    datasetService.upload(new DatasetUploadMetadata(name, type, endpoint, csvconfiguration), file)
    .catchError((e)=>onError(e, loadAll))
    .then((_){
      loadAll();
    });
  }
  
}

class DatasetUploadMetadata {
  String name;
  MediaType type;
  String endpoint;
  CSVConfiguration csvConfiguration;
  
  DatasetUploadMetadata(this.name, this.type, this.endpoint, [this.csvConfiguration]);
}

class CSVConfiguration {
  String delimiter;
  String encoding;
  String quote;
  
  CSVConfiguration(this.delimiter, this.encoding, this.quote);  
  
}

