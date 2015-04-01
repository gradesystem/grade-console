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
  String label;
  
  String uri;
  String endpoint;
  bool inverse;
 
  NavigatorService service;
  
  Navigator.created() : super.created();
  
  void ready() {
    service = new NavigatorService();
    window.onPopState.listen(onPopState);
    
    navigateCurrentParameters();
  }
  
  void navigateCurrentParameters() {
    var parameters = getUrlParameters();
    result.history.init(new DescribeCrumb(parameters["uri"], "", parameters["inverse"]?DescribeType.DESCRIBE_BY_OBJECT:DescribeType.DESCRIBE_BY_SUBJECT));
    resolveUri(parameters["endpoint"], parameters["uri"], parameters["inverse"]);
  }
  
  Map getUrlParameters() {
    Location location = document.window.location; 
    Uri locationUri = Uri.parse(location.href);
    String uri = locationUri.queryParameters["uri"];
    String endpoint = locationUri.queryParameters["endpoint"];
    String inverse = locationUri.queryParameters["inverse"];
    bool inv = inverse !=null && inverse.toLowerCase() == "true";
    String index = locationUri.queryParameters["index"];
    return {"endpoint":endpoint, "uri":uri,"inverse":inv, "index":index};
  }
  
  void resolveUri(String endpoint, String uri, bool inverse, [RawFormat format = RawFormat.JSON]) {
    
    this.endpoint = endpoint;
    this.uri = uri;
    this.inverse = inverse;
    
    this.label = uri;
    
    result.loading = true;
    result.loadingRaw = true;
    
    service.resolve(endpoint, uri, inverse, format).then((String response) {
      //print('response: $response');
      
      if (format == RawFormat.JSON) {
        NavResultTable resultTable = new NavResultTable(JSON.decode(response));
        result.value = resultTable;
        if (resultTable.label!=null) this.label = resultTable.label;
      }
      result.raws[format] = response;
    }).whenComplete(() {
      result.loading = false;
      result.loadingRaw = false;
    });
  }
  
  void onEatCrumb(event, detail, target) {
    Crumb crumb = detail;
    if (crumb is DescribeCrumb) {
      String uri = crumb.uri;
      bool inverse = crumb.type == DescribeType.DESCRIBE_BY_OBJECT;
      
      if (this.uri != uri || this.inverse != inverse) {
        pushState(endpoint, uri, inverse);
        result.clean();
        resolveUri(endpoint, uri, inverse);
      }
    }
  }
  
  void onLoadRawResult(event, detail, target) {
    RawFormat format = detail;
    resolveUri(endpoint, uri, inverse, format);
  }
  
  void pushState(String endpoint, String uri, bool inverse) {
    print('pushState endpoint: $endpoint uri: $uri inverse: $inverse');
    
    Location location = document.window.location; 
    Uri locationUri = Uri.parse(location.href);
    int index = result.history.currentIndex;
    Uri url = locationUri.replace(queryParameters: {"endpoint":endpoint, "uri":uri,"inverse":"$inverse", "index":"$index"});

    window.history.pushState(null, title, url.toString());
  }
  
  void onPopState(PopStateEvent event) {

    var parameters = getUrlParameters();
    print('onPopState parameters $parameters state: ${event.state} ${event}');

    resolveUri(parameters["endpoint"], parameters["uri"], parameters["inverse"]);
    
    String indexParam = parameters["index"];
    int index = indexParam!=null?int.parse(indexParam):0;
    result.history.goIndex(index);
  }
     
}

class NavResultTable extends ResulTable {
  
  static final String PROPERTY = "Property";
  static final String VALUE = "Value";
  
  List<Map<String, Map>> rows;
  String label;
  
  NavResultTable(Map bean) : super(bean) {
    this.rows = super.rows.map((Map<String, Map> row){
      Map predicate = row["predicate"];
      Map object = row["object"];
      if (predicate["value"] == "http://www.w3.org/2000/01/rdf-schema#label") label = object["value"];
      return {
        PROPERTY:predicate,
        VALUE:object
      };
    }).toList();
  }
  
  List<String> get headers => [PROPERTY,VALUE];
  
}


class NavigatorService {
  
  GradeService http;
  
  NavigatorService() {
    String base_url = "prod/endpoint";
    http = new GradeService(base_url);
  }
  
  Future<String> resolve(String endpoint, String uri, bool inverse, RawFormat format) {
    String path = "$endpoint/resolve";
    Map parameters = {"uri":uri,"backwards":"$inverse"};
    //print('path: $path, parameters: $parameters');
    return http.get(path, parameters:parameters, acceptedMediaType: format.value);
  }
  
}
