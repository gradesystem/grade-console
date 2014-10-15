part of datasets;

abstract class DatasetService {
  
  static String base_url = "service";
  
  String service_url;
  String all_path;
  
  HttpService http;
  
  DatasetService(this.http, String path, [this.all_path = "datasets"]) {
    service_url = "$base_url/$path";
  }
  
  Future<List<Dataset>> getAll() {
    return http.get("$service_url/$all_path").then((json)=>new ListDelegate(json, toDataset));
  }
  
  Dataset toDataset(Map json) {
    return new Dataset(json);
  }
}