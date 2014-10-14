part of datasets;

abstract class DatasetService {
  
  static String base_url = "service";
  
  String service_url;
  
  HttpService http;
  
  DatasetService(this.http, String path) {
    service_url = "$base_url/$path";
  }
  
  Future<List<Dataset>> getAll() {
    return http.get("$service_url/datasets").then((json)=>new ListDelegate(json, toDataset));
  }
  
  Dataset toDataset(Map json) {
    return new Dataset(json);
  }
}