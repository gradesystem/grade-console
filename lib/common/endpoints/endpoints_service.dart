part of endpoints;

abstract class EndpointsService extends ListService<Endpoint> {

  EndpointsService(String path) : super(path, "endpoints", (Map json) => new Endpoint.fromBean(json));
  
  dynamic _decode(String json) {
    try {
      return JSON.decode(json);
    } catch(e) {
      throw new ErrorResponse(-1, "Failed parsing response", "Response: $json");
    }
  }

  Future<bool> putEndpoint(Endpoint endpoint) {
    return http.post("endpoints", JSON.encode(endpoint.bean)).then((response) => true);
  }

  Future<bool> deleteEndpoint(Endpoint endpoint) {
    return http.delete("endpoint/${endpoint.name}").then((response) => true);
  }
}
