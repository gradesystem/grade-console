part of common;


class GradeService {
  Duration timeLimit = new Duration(minutes: 3);
  
  String base_path;

  GradeService(String service_path) {
    base_path = "service/$service_path";
  }
  
  Future getJSon(String path, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.getString(url.toString())
        .timeout(timeLimit)
        .then((String response) => JSON.decode(response))
        .catchError(_onError);
  }
  
  Future get(String path, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.getString(url.toString())
        .timeout(timeLimit)
        .catchError(_onError);
  }
  
  Future<String> post(String path, String content, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.post(url.toString(), content)
        .timeout(timeLimit)
        .then((xhr) => xhr.responseText)
        .catchError(_onError);
  }

  Future<String> delete(String path) {
    Uri url = new Uri.http("", "$base_path/$path");
    return HttpService.delete(url.toString())
        .timeout(timeLimit)
        .then((xhr) => xhr.responseText)
        .catchError(_onError);
  }
  
  ErrorResponse _onError(e) {
    if (e is HttpRequestException) {
      try {
        var json = JSON.decode(e.responseText);
        if (json is Map && json.containsKey("code")) throw new ErrorResponse.fromJSon(json);
      } catch(Exception) {}
      throw new ErrorResponse(e.status, e.statusText, e.responseText);
    }
    throw new ErrorResponse(-1, "", e.toString());
  }
  
}

class ErrorResponse {
  
  int code;
  String message;
  String stacktrace;
  
  ErrorResponse(this.code, this.message, this.stacktrace);
  ErrorResponse.fromJSon(Map bean):this(bean["code"], bean["msg"], bean["stacktrace"]);

  String toString() => "Error: $code $message $stacktrace";
}

class HttpService {
  
  static String CONTENT_TYPE = "application/json; charset=UTF-8";
  
  static Future<HttpRequest> delete(String url, {bool withCredentials, String responseType, Map<String, String> requestHeaders, void onProgress(ProgressEvent e)}) {

    return request(url, method: 'DELETE', withCredentials: withCredentials, responseType: responseType, requestHeaders: requestHeaders, onProgress: onProgress);
  }

  static Future<HttpRequest> post(String url, String content, {bool withCredentials, String responseType, Map<String, String> requestHeaders, void onProgress(ProgressEvent e)}) {

    if (requestHeaders == null) {
      requestHeaders = <String, String>{};
    }
    requestHeaders.putIfAbsent('Content-Type', () => CONTENT_TYPE);

    return request(url, method: 'POST', withCredentials: withCredentials, responseType: responseType, requestHeaders: requestHeaders, sendData: content, onProgress: onProgress);
  }

  static Future<String> getString(String url, {bool withCredentials, void onProgress(ProgressEvent e)}) {
    return request(url, withCredentials: withCredentials, onProgress: onProgress).then((xhr) => xhr.responseText);
  }

  static Future<HttpRequest> request(String url, {String method, bool withCredentials, String responseType, String mimeType, Map<String, String> requestHeaders, sendData, void onProgress(ProgressEvent e)}) {
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
      if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 0 || xhr.status == 304) {
        completer.complete(xhr);
      } else {
        completer.completeError(new HttpRequestException(url, xhr.status, xhr.statusText, xhr.responseText));
      }
    });


    xhr.onError.listen((_) => completer.completeError(new HttpRequestException(url, xhr.status, xhr.statusText, xhr.responseText)));

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
  String responseText;

  HttpRequestException(this.url, this.status, this.statusText, this.responseText);

  String toString() => "$url $status error: $statusText message: $responseText";

}



