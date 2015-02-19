part of datasets;

class Dataset extends GradeEntity with Filters {

  Dataset(Map bean) : super(bean);
  
   static final String id = "uri";
   static final List<String> labels = [
                                       "label",
                                       "http://www.w3.org/2000/01/rdf-schema#label",
                                       "http://purl.org/dc/terms/title"
                                      ];
   
  String get title {
                    
      for (String lbl in labels) {
         String label = get(lbl);
         if (label!=null)
           return label;
      }

      return get(id);
   }
  
  DateTime get creationDate => getDate("http://purl.org/dc/terms/created");
   
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
  
  DatasetsPageModel(PageEventBus bus, ListService<Dataset> service, ListItems<Dataset> storage):super(bus, service, storage) {
    bus.on(GraphOperation).listen((_)=>loadAll());
    bus.on(EndpointOperation).listen((_)=>loadAll());
  }
  
  DatasetService get datasetService => service;
  
  Future<bool> uploadDataset(DatasetUploadMetadata metadata, File file) {
    return datasetService.upload(metadata, file)
    .then((_){
      loadAll();
      bus.fireInPage(new DatasetUploaded(metadata.endpointId));
      return true;
    });
  }
  
}

class DatasetUploadMetadata {
  String name;
  String author;
  MediaType type;
  String endpointId;
  CSVConfiguration csvConfiguration;
  
  DatasetUploadMetadata(this.name, this.author, this.type, this.endpointId, [this.csvConfiguration]);
}

class CSVConfiguration {
  String delimiter;
  String encoding;
  String quote;
  
  CSVConfiguration(this.delimiter, this.encoding, this.quote);  
  
}

