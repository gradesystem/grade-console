part of common;

class GradeService {
  Duration timeLimit = new Duration(minutes: 3);

  String base_path;

  GradeService(String service_path) {
    base_path = "service/$service_path";
  }

  Future getJSon(String path, {MediaType acceptedMediaType:MediaType.JSON, Map<String, String> parameters}) {
    Uri url = new Uri.http("", "$base_path/$path", parameters);
    return HttpService.getString(url.toString(), acceptedMediaType:acceptedMediaType).timeout(timeLimit, onTimeout:timeout).then(decode).catchError(_onError);
  }

  dynamic decode(String json) {
    try {
      return JSON.decode(json);
    } catch (e) {
      throw new ErrorResponse(-1, "Failed parsing response", "Response: $json");
    }
  }

  Future get(String path, {MediaType acceptedMediaType:MediaType.JSON, Map<String, String> parameters}) 
    => HttpService.getString(toUri(path, parameters), acceptedMediaType:acceptedMediaType).timeout(timeLimit, onTimeout:timeout).catchError(_onError);

  Future<String> post(String path, dynamic content, {MediaType acceptedMediaType:MediaType.JSON, MediaType contentType : MediaType.JSON, Map<String, String> parameters}) 
    => HttpService.request(toUri(path, parameters), method:'POST', sendData: content, acceptedMediaType:acceptedMediaType, contentType: contentType).timeout(timeLimit, onTimeout:timeout).then((xhr) => xhr.responseText).catchError(_onError);
  
  Future<String> put(String path, dynamic content, {MediaType acceptedMediaType:MediaType.JSON, MediaType contentType : MediaType.JSON, Map<String, String> parameters}) 
    => HttpService.request(toUri(path, parameters), method:'PUT', sendData: content, acceptedMediaType:acceptedMediaType, contentType: contentType).timeout(timeLimit, onTimeout:timeout).then((xhr) => xhr.responseText).catchError(_onError);
  
  Future<dynamic> postJSon(String path, String content, {MediaType acceptedMediaType:MediaType.JSON, Map<String, String> parameters}) 
    => post(path, content, acceptedMediaType:acceptedMediaType, parameters:parameters).then(decode).catchError(_onError);
  
  Future<String> postFormData(String path, FormData data, Map<String, String> parameters) 
    => HttpService.request(toUri(path, parameters), method: 'POST', sendData: data).timeout(timeLimit, onTimeout:timeout).then((xhr) => xhr.responseText).catchError(_onError);

  Future<String> delete(String path, [Map<String, String> parameters]) 
    => HttpService.request(toUri(path, parameters), method:'DELETE',contentType: MediaType.JSON, acceptedMediaType: MediaType.SPARQL_JSON).timeout(timeLimit, onTimeout:timeout).then((xhr) => xhr.responseText).catchError(_onError);
  
  String toUri(String path, [Map<String, String> parameters])
    => new Uri.http("", "$base_path/$path", parameters).toString();

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
    if (e is Error) throw new ErrorResponse(-1, e.toString(), e.stackTrace.toString());
    throw new ErrorResponse(-1, "", e.toString());
  }
  
  void timeout() {
    throw new ErrorResponse(-1, "This is taking too long, longer than the network can wait. It's a timeout.", "This is taking too long, longer than the network can wait. It's a timeout.");
  }

}

class MediaType {
  
  static UnmodifiableListView<MediaType> values = new UnmodifiableListView([SPARQL_JSON, JSON, TURTLE, NTRIPLES, JSONLD, RDF_XML, SPARQL_XML, XML, CSV]);

  static MediaType parse(String value) => values.firstWhere((MediaType o) => o._value == value || o.alternatives.contains(value), orElse: () => null);
   
  final String _value;
  final List<String> _alternatives;
  const MediaType._internal(this._value, [this._alternatives = const []]);
  toString() => 'MediaType.$_value';
  
  String get value => _value;
  List<String> get alternatives => _alternatives;
   
  static const SPARQL_JSON = const MediaType._internal('application/sparql-results+json');
  static const JSON = const MediaType._internal('application/json');
  static const TURTLE = const MediaType._internal('text/turtle');
  static const NTRIPLES = const MediaType._internal('application/n-triples');
  static const JSONLD = const MediaType._internal('application/ld+json');
  static const RDF_XML = const MediaType._internal('application/rdf+xml');
  static const SPARQL_XML = const MediaType._internal('application/sparql-results+xml');
  static const XML = const MediaType._internal('application/xml',const ['text/xml']);
  static const CSV = const MediaType._internal('text/csv');

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

  static Future<String> getString(String url, {bool withCredentials, MediaType acceptedMediaType : MediaType.JSON, MediaType contentType : MediaType.JSON, void onProgress(ProgressEvent e)}) 
    => request(url, method: 'GET', withCredentials: withCredentials, onProgress: onProgress, acceptedMediaType: acceptedMediaType, contentType:contentType).then((xhr) => xhr.responseText);
  
  static Future<HttpRequest> request(String url, {String method, bool withCredentials, String responseType, String mimeType, Map<String, String> requestHeaders, sendData, MediaType acceptedMediaType, MediaType contentType, void onProgress(ProgressEvent e)}) {
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
    
    if (contentType != null) {
      xhr.setRequestHeader('Content-Type', contentType.value);
    }
    
    if (acceptedMediaType != null) {
      xhr.setRequestHeader('Accept', acceptedMediaType.value);
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


