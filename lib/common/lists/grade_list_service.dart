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
  
  Future<bool> put(T item) {
    Completer<bool> completer = new Completer<bool>();
    new Timer(new Duration(seconds: 3), () {
          if (fail) completer.completeError(new Exception("Simulated failure"));
          else completer.complete(true);
         
         fail = !fail;
        });
    return completer.future;
  }
}