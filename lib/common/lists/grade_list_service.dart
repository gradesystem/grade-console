part of lists;

abstract class ListService<T extends Delegate> extends Dependencies {
   
  Generator<T> generator;
  
  String path;
  String all_path;
  String single_item_path;
  
  GradeService http;
  
  ListService(this.path, this.all_path, this.single_item_path, this.generator) {
    this.http = new GradeService(path);
  }
  
  Future<List<T>> getAll() {
    return http.getJSon(all_path).then((json)=>new ListDelegate(json, generator));
  }
  
  Future<T> get(String key) {
    return http.getJSon(getItemPath(key)).then(generator);
  }
  
  Future<T> put(T item) {
    return http.postJSon(all_path, JSON.encode(item.bean)).then(generator);
  }

  Future<bool> delete(String key, [Map<String, String> parameters]) {
    return http.delete(getItemPath(key), parameters).then((response) => true);
  }
  
  String getItemPath(String key) => "$single_item_path/$key";
}
