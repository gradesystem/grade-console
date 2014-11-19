part of endpoints;

abstract class EndpointsService extends EditableListService<Endpoint> {

  EndpointsService(String path) : super(path, "endpoints", "endpoint", (Map json) => new Endpoint.fromBean(json));
  
  Future<bool> deleteEndpointGraph(Endpoint endpoint, String graph) {
    return http.delete(getGraphPath(endpoint.name), {"uri":graph}).then((response) => true);
  }
  
  Future<bool> addEndpointGraph(Endpoint endpoint, String graph) {
    return http.postJSon(getGraphPath(endpoint.name), "", {"uri":graph}).then((response) => true);
  }
  
  String getGraphPath(String key) => "${getItemPath(key)}/graphs";
}
