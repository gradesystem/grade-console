part of common;

@Injectable()
class HttpService {

  Future<List> get(String url) {
    return HttpRequest.getString(url).then((String response)=>JSON.decode(response));
  }
}


