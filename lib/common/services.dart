part of common;


class GradeService {
  Duration timeLimit = new Duration(minutes: 3);

  String base_path;

  GradeService(String service_path) {
    base_path = "service/$service_path";
  }

  Future getJSon(String path, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.getString(url.toString()).timeout(timeLimit).then(_decode).catchError(_onError);
  }

  dynamic _decode(String json) {
    try {
      return JSON.decode(json);
    } catch (e) {
      throw new ErrorResponse(-1, "Failed parsing response", "Response: $json");
    }
  }

  Future get(String path, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.getString(url.toString()).timeout(timeLimit).catchError(_onError);
  }

  Future<String> post(String path, String content, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.post(url.toString(), content, acceptedMediaType:MediaType.SPARQL_JSON).timeout(timeLimit).then((xhr) => xhr.responseText).catchError(_onError);
  }
  
  Future postJSon(String path, String content, [Map<String, String> parameters]) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.post(url.toString(), content, acceptedMediaType:MediaType.JSON).timeout(timeLimit).then((xhr) => xhr.responseText).then(_decode).catchError(_onError);
  }

  Future<String> delete(String path) {
    Uri url = new Uri.http("", "$base_path/$path");
    return HttpService.delete(url.toString()).timeout(timeLimit).then((xhr) => xhr.responseText).catchError(_onError);
  }

  ErrorResponse _onError(e) {
    if (e is HttpRequestException) {
      var json;
      try {
        json = JSON.decode(e.responseText);
      } catch (error) {
      }
      if (json != null && json is Map && json.containsKey("code")) throw new ErrorResponse.fromJSon(json); 
      else throw new ErrorResponse(e.status, e.statusText, e.responseText);
    }
    throw new ErrorResponse(-1, "", e.toString());
  }

}

class MediaType {
   
  final _value;
  const MediaType._internal(this._value);
  toString() => 'MediaType.$_value';
  
  String get value => _value;
   
  static const SPARQL_JSON = const MediaType._internal('application/sparql-results+json');
  static const JSON = const MediaType._internal('application/json; charset=UTF-8');
}

class ErrorResponse {

  int code;
  String message;
  String stacktrace;

  ErrorResponse(this.code, this.message, this.stacktrace);
  ErrorResponse.fromJSon(Map bean) : this(bean["code"], bean["msg"], bean["stacktrace"]);
  
  bool isClientError() {
    return (code>=400 && code<500);
  }

  String toString() => "Error: $code $message $stacktrace";
}

class HttpService {

  static String MEDIA_TYPE_JSON = "application/json; charset=UTF-8";
  static String MEDIA_TYPE_SPARQL_JSON = "application/sparql-results+json";

  static Future<HttpRequest> delete(String url, {bool withCredentials, String responseType, Map<String, String> requestHeaders, void onProgress(ProgressEvent e)}) {

    return request(url, method: 'DELETE', withCredentials: withCredentials, responseType: responseType, requestHeaders: {
      'Content-Type': MEDIA_TYPE_JSON,
      'Accept': MEDIA_TYPE_SPARQL_JSON
    }, onProgress: onProgress);
  }

  static Future<HttpRequest> post(String url, String content, {bool withCredentials, String responseType, MediaType acceptedMediaType, void onProgress(ProgressEvent e)}) {
    return request(url, method: 'POST', withCredentials: withCredentials, responseType: responseType, requestHeaders: {
      'Content-Type': MEDIA_TYPE_JSON,
      'Accept': acceptedMediaType.value
    }, sendData: content, onProgress: onProgress);
  }

  static Future<String> getString(String url, {bool withCredentials, void onProgress(ProgressEvent e)}) {
    return request(url, withCredentials: withCredentials, onProgress: onProgress, requestHeaders: {
      'Content-Type': MEDIA_TYPE_JSON,
      'Accept': MEDIA_TYPE_JSON
    }).then((xhr) => xhr.responseText);
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


