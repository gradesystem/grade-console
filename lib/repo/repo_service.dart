part of repo;

@Injectable()
class RepoService {
  
  String url = "graphs.json";
  
  HttpService http;
  
  RepoService(this.http);
  
  Future<List<Graph>> getAll() {
    Completer<List<Graph>> completer = new Completer<List<Graph>>();
    
    http.get(url).then((Map json){
      completer.complete(toGraphs(json, 'list'));
    });
    return completer.future;
  }
  
  Graph toGraph(Map json) {
    return new Graph(json);
  }
  
  List<Graph> toGraphs(Map json, String field) {
    return new ListDelegate(json[field], toGraph);
  }

}
