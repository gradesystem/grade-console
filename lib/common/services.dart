part of common;

@Injectable()
class HttpService {

  Future<List> get(String url) {
    Completer<List> completer = new Completer<List>();
    HttpRequest.getString(url).then((String response) {

      try {
        List json = JSON.decode(response);
        completer.complete(json);
      } catch (error) {
        completer.completeError(error);
      }

    }).catchError((e) => completer.completeError(e));

    return completer.future;
  }
}


