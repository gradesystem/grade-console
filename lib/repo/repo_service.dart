part of repo;

@Injectable()
class RepoService {
  
  String url = "service/prod/datasets";
  
  HttpService http;
  
  RepoService(this.http);
  
  Future<List<Graph>> getAll() {
    Completer<List<Graph>> completer = new Completer<List<Graph>>();
    
    http.get(url).then((List json){
      completer.complete(new ListDelegate(json, toGraph));
    });
    return completer.future;
  }
  
  Graph toGraph(Map json) {
    return new Graph(json);
  }
}
