part of prod;

@Injectable()
class ProdService {
  
  String url = "service/prod/datasets";
  
  HttpService http;
  
  ProdService(this.http);
  
  Future<List<Dataset>> getAll() {
    Completer<List<Dataset>> completer = new Completer<List<Dataset>>();
    
    http.get(url).then((List json){
      completer.complete(new ListDelegate(json, toGraph));
    });
    return completer.future;
  }
  
  Dataset toGraph(Map json) {
    return new Dataset(json);
  }
}
