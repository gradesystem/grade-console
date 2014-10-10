part of datasets;

abstract class DatasetService {
  
  static String base_url = "service";
  
  String service_url;
  
  HttpService http;
  
  DatasetService(this.http, String path) {
    service_url = "$base_url/$path/";
  }
  
  Future<List<Dataset>> getAll() {
    Completer<List<Dataset>> completer = new Completer<List<Dataset>>();
    
    http.get("$service_url/datasets").then((List json){
      completer.complete(new ListDelegate(json, toDataset));
    });
    return completer.future;
  }
  
  Dataset toDataset(Map json) {
    return new Dataset(json);
  }
}