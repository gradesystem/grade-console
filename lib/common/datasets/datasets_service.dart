part of datasets;

class DatasetService extends ListService<Dataset> {
  
  DatasetService(String path):super(path, "datasets", "", toDataset);

  static Dataset toDataset(Map json) {
    return new Dataset(json);
  }
  
  Future<String> upload(DatasetUploadMetadata metadata, File file) {
    
    String type = getTypeLabel(metadata.type);
    String path = "endpoint/${metadata.endpointId}/dropin/$type/${metadata.name}";
        
    if (metadata.type == MediaType.CSV && metadata.csvConfiguration!=null) {
      
       FormData data = new FormData();
       
       CSVConfiguration csv = metadata.csvConfiguration;
       String csvConfigurationJson = JSON.encode({"delimiter":csv.delimiter, "encoding":csv.encoding, "quote":csv.quote});
       Blob csvConfigurationBlob = new Blob([csvConfigurationJson], MediaType.JSON.value);
       data.appendBlob("info", csvConfigurationBlob);
       
       data.appendBlob("content", file);
       
       return http.postFormData(path, data, {});

    } else {
      return load(file).then((fileContent) => http.post(path, fileContent, contentType:metadata.type));
    }
  }
  
  String getTypeLabel(MediaType type) {
    switch(type) {
      case MediaType.XML: return "xml";
      case MediaType.JSON: return "json";
      case MediaType.CSV: return "csv";
      default: throw new ArgumentError("Unmappable media type $type");
    }
  }
  
  Future load(File file) {
    Completer completer = new Completer();
    
    FileReader reader = new FileReader();
        reader.onLoad.listen((_){
          completer.complete(reader.result);
        });
        reader.readAsArrayBuffer(file);
    
    return completer.future;
         
  }
}