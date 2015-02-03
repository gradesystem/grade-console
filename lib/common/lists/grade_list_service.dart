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
    return http.getJSon(all_path).then((json) {
      return new ListDelegate(json, generator);
    });
  }
  
  Future<T> get(String key) {
    return http.getJSon(getItemPath(key)).then(generator);
  }
  
  String getItemPath(String key) => "$single_item_path/$key";
}
