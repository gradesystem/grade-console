part of lists;

abstract class ListService<T extends ListItem> extends Dependencies {
   
  Generator<T> generator;
  
  String path;
  String all_path;
  
  GradeService http;
  
  ListService(this.path, this.all_path, this.generator) {
    this.http = new GradeService(path);

  }
  
  Future<List<T>> getAll() {
    return http.getJSon(all_path).then((json)=>new ListDelegate(json, generator));
  }
}
