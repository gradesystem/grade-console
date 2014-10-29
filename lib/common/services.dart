part of common;

@Injectable()
class HttpService {
  
  Duration timeLimit = new Duration(minutes: 3);

  Future get(String url) {
    return getString(url).timeout(timeLimit).then((String response)=>JSON.decode(response));
  }
  
  Future<String> postJSon(String url, String json,
        {bool withCredentials, String responseType,
        Map<String, String> requestHeaders,
        void onProgress(ProgressEvent e)}) {

      if (requestHeaders == null) {
        requestHeaders = <String, String>{};
      }
      requestHeaders.putIfAbsent('Content-Type',
          () => 'application/json; charset=UTF-8');

      return request(url, method: 'POST', withCredentials: withCredentials,
          responseType: responseType,
          requestHeaders: requestHeaders, sendData: json,
          onProgress: onProgress).then((xhr) => xhr.responseText);
    }
  
  Future<String> getString(String url,
        {bool withCredentials, void onProgress(ProgressEvent e)}) {
    return request(url, withCredentials: withCredentials,
        onProgress: onProgress).then((xhr) => xhr.responseText);
  }
  
  static Future<HttpRequest> request(String url,
        {String method, bool withCredentials, String responseType,
        String mimeType, Map<String, String> requestHeaders, sendData,
        void onProgress(ProgressEvent e)}) {
      var completer = new Completer<HttpRequest>();

      var xhr = new HttpRequest();
      if (method == null) {
        method = 'GET';
      }
      xhr.open(method, url, async: true);

      if (withCredentials != null) {
        xhr.withCredentials = withCredentials;
      }

      if (responseType != null) {
        xhr.responseType = responseType;
      }

      if (mimeType != null) {
        xhr.overrideMimeType(mimeType);
      }

      if (requestHeaders != null) {
        requestHeaders.forEach((header, value) {
          xhr.setRequestHeader(header, value);
        });
      }

      if (onProgress != null) {
        xhr.onProgress.listen(onProgress);
      }

      xhr.onLoad.listen((e) {
        // Note: file:// URIs have status of 0.
        if ((xhr.status >= 200 && xhr.status < 300) ||
            xhr.status == 0 || xhr.status == 304) {
          completer.complete(xhr);
        } else {
          completer.completeError(new HttpRequestException(url, xhr.status, xhr.statusText));
        }
      });

      xhr.onError.listen((_)=>completer.completeError(new HttpRequestException(url, xhr.status, xhr.statusText)));

      if (sendData != null) {
        xhr.send(sendData);
      } else {
        xhr.send();
      }

      return completer.future;
    }
}

class HttpRequestException implements Exception {
  
  String url;
  int status;
  String statusText;
  
  HttpRequestException(this.url, this.status, this.statusText);
  
  String toString() => "$url $status error: $statusText";
  
}


