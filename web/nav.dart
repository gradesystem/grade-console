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
  
  String originUrl;
 
  NavigatorService service;
  
  Navigator.created() : super.created();
  
  void ready() {
    service = new NavigatorService();
    window.onPopState.listen(onPopState);
    
    navigateCurrentParameters();
  }
  
  void navigateCurrentParameters() {

    var parameters = getUrlParameters();
    calculateOriginUrl(parameters);
    
    result.history.init(new DescribeCrumb(parameters["uri"], "", parameters["inverse"]?DescribeType.DESCRIBE_BY_OBJECT:DescribeType.DESCRIBE_BY_SUBJECT));
    resolveUri(parameters["endpoint"], parameters["uri"], parameters["inverse"]);
  }
  
  void calculateOriginUrl(Map parameters) {
    String uriParam = parameters["uri"];
    String endpoint = parameters["endpoint"];
    
    if (uriParam == null || endpoint == null) return;
    
    Uri uri = Uri.parse(uriParam);
    String uriValue = Uri.parse(uriParam).toString();
    
    print('uriValue: $uriValue');
    
    int endpointIndex = uriValue.indexOf("/$endpoint/");
    if (endpointIndex>=0) originUrl = uriValue.substring(0,endpointIndex);
    else originUrl = uri.authority;
    
    print('originUrl $originUrl');
  }
  
  bool sameOrigin(String url) => originUrl!=null && url.startsWith(originUrl);
  
  String extractEndpoint(String url) {
    if (originUrl==null || originUrl.length>url.length) return "";
    
    String urlPart = url.substring(originUrl.length + 1);
    int index = urlPart.indexOf("/");
    return index>=0?urlPart.substring(0,index):urlPart;
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
    
    if (uri == null || endpoint == null) return;
    
    this.endpoint = endpoint;
    this.uri = uri;
    this.inverse = inverse;
    
    this.label = uri;
    
    result.loading = true;
    result.loadingRaw = true;
    
    service.resolve(endpoint, uri, inverse, format).then((String response) {
      //print('response: $response');
      
      if (format == RawFormat.JSON) {
        Map json = JSON.decode(response);
        NavResultTable resultTable = new NavResultTable(json);
       // addUriInformation(resultTable);
        result.value = resultTable;
        String label = getLabel(json);
        if (label!=null) this.label = label;
      }
      result.raws[format] = response;
    })
    .catchError((ErrorResponse error){
      if (error.code == 404) redirectTo(uri);
    })
    .whenComplete(() {
      result.loading = false;
      result.loadingRaw = false;
    });
  }
  
  String getLabel(Map json) {
    List<Map<String, Map>> rows = json["results"]["bindings"];
    
    String label;
    
    bool isPref = false;
    bool isEng = false;
    
    rows.forEach((Map<String, Map> row){
      Map predicate = row["predicate"];
      Map object = row["object"];
      
      if (predicate["value"] == "http://www.w3.org/2004/02/skos/core#prefLabel" && (!isPref || !isEng)) {
        label = object["value"];
        isPref = true;
        isEng = object["xml:lang"] == "en";
      }
      
      if (predicate["value"] == "http://www.w3.org/2000/01/rdf-schema#label" && !isPref && (label!=null && !isEng || label==null)) {
        label = object["value"];
        isEng = object["xml:lang"] == "en";
      }
      
    });
    
    return label;

  }
  
  /*void addUriInformation(ResulTable result) {
    for (Map<String, Map> row in result.rows) {
      for (String header in result.headers) {
        Map cell = row[header];
        String type = cell["type"];
        String value = cell["value"];
        if (type != null && type == "uri" && value !=null) {
          cell["internal-uri"] = sameOrigin(uri);
        }
      }
    }
  }*/
  
  void onEatCrumb(event, detail, target) {
    print('onEatCrumb $detail');
    Crumb crumb = detail;
    if (crumb is DescribeCrumb) {
      String uri = crumb.uri;
      bool inverse = crumb.type == DescribeType.DESCRIBE_BY_OBJECT;

      if (this.uri != uri || this.inverse != inverse) {
        
        print('originUrl $originUrl');
        
        if (sameOrigin(uri) || inverse) {
          
          String endpoint = sameOrigin(uri)?extractEndpoint(uri):this.endpoint;
          print("endpoint: $endpoint");
          
          pushState(endpoint, uri, inverse);
          result.clean();
          resolveUri(endpoint, uri, inverse);
        } else {
          result.history.removeLastCrumb();
          redirectTo(uri);
        }
      }
    }
  }
  
  void redirectTo(String uri) {
    window.open(uri, "");
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
  
  NavResultTable(Map bean) : super(bean) {
    this.rows = super.rows.map((Map<String, Map> row){
      return {
        PROPERTY:row["predicate"],
        VALUE:row["object"]
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
