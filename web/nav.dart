library navigator;

import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:polymer/polymer.dart';

import 'package:grade_console/common/queries/queries.dart';
import 'package:grade_console/common.dart';

void main() {
  
   initPolymer().run(() {});
}

@CustomTag("grade-nav")
class Navigator extends PolymerElement {
  
  @observable
  int resultTab = 0;
  
  @observable
  Result result = new Result();
  
  @observable
  String uri;
  String endpoint;
  bool inverse;
 
  NavigatorService service;
  
  Navigator.created() : super.created();
  
  void ready() {
    service = new NavigatorService();
    navigateCurrentParameters();
  }
  
  void navigateCurrentParameters() {
    Location location = document.window.location; 
    Uri locationUri = Uri.parse(location.href);
    String uri = locationUri.queryParameters["uri"];
    String endpoint = locationUri.queryParameters["endpoint"];
    
    result.clean();
    resolveUri(endpoint, uri, false);
  }
  
  void resolveUri(String endpoint, String uri, bool inverse, [RawFormat format = RawFormat.JSON]) {
    
    this.endpoint = endpoint;
    this.uri = uri;
    this.inverse = inverse;
    
    result.loading = true;
    result.loadingRaw = true;
    
    service.resolve(endpoint, uri, inverse, format).then((String response) {
      print('response: $response');
      if (format == RawFormat.JSON) result.value = new ResulTable(JSON.decode(response));
      result.raws[format] = response;
    }).whenComplete(() {
      result.loading = false;
      result.loadingRaw = false;
    });
  }
  
  void onEatCrumb(event, detail, target) {
    Crumb crumb = detail;
    if (crumb is DescribeCrumb) {
      result.clean();
      resolveUri(endpoint, crumb.uri, crumb.type == DescribeType.DESCRIBE_BY_OBJECT);
    }
  }
  
  void onLoadRawResult(event, detail, target) {
    RawFormat format = detail;
    resolveUri(endpoint, uri, inverse, format);
  }
     
}

class NavigatorService {
  
  GradeService http;
  
  NavigatorService() {
    String base_url = "prod/endpoint";
    http = new GradeService(base_url);
  }
  
  Future<String> resolve(String endpoint, String uri, bool inverse, RawFormat format) {
    String path = "$endpoint/resolve";
    Map parameters = {"uri":uri,"inverse":"$inverse"};
    print('path: $path, parameters: $parameters');
    return http.get(path, parameters:parameters, acceptedMediaType: format.value);
  }
  
}
