part of endpoints;

abstract class EndpointsService extends ListService<Endpoint> {

  EndpointsService(String path) : super(path, "endpoints", "endpoint", (Map json) => new Endpoint.fromBean(json));

  Future<bool> deleteEndpoint(Endpoint endpoint) {
    return delete(endpoint, endpoint.name);
  }
}
