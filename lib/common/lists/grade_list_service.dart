part of lists;

abstract class ListService<T extends ListItem> extends Dependencies {
  
  static bool fail = true;
  static String base_url = "service";
  
  Generator<T> generator;
  
  String path;
  
  String service_url;
  String all_path;
  
  HttpService http;
  
  ListService(this.path, this.all_path, this.generator) {
    this.http = instanceOf(HttpService);
    
    service_url = "$base_url/$path";
  }
  
  Future<List<T>> getAll() {
    return http.get("$service_url/$all_path").then((json)=>new ListDelegate(json, generator));
  }
}