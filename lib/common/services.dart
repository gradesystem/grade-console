part of common;

@Injectable()
class HttpService {

  Future<Map> get(String url) {
    Completer<Map> completer = new Completer<Map>();
    HttpRequest.getString(url).then((String response) {

      try {
        Map json = JSON.decode(response);
        completer.complete(json);
      } catch (error) {
        completer.completeError(error);
      }

    }).catchError((Error error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
