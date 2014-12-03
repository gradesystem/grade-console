part of endpoints;

abstract class EndpointsService extends EditableListService<Endpoint> {

  EndpointsService(String path) : super(path, "endpoints", "endpoint", (Map json) => new Endpoint.fromBean(json));
  
  Future<bool> deleteEndpointGraph(Endpoint endpoint, Graph graph) {
    return http.delete(getGraphPath(endpoint.name), {"uri":graph.uri}).then((response) => true);
  }
  
  Future<bool> addEndpointGraph(Endpoint endpoint, Graph graph) {
    return http.post(getGraphPath(endpoint.name), graph.toJson()).then((_) => true);
  }
  
  String getGraphPath(String key) => "${getItemPath(key)}/graphs";
}
