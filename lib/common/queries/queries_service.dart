part of queries;

abstract class QueryService extends ListService<Query> {

  QueryService(String path) : super(path, "queries", (Map json) => new Query.fromBean(path, json));

  Future<QueryResult> runQueryByName(Query query, Map<String, String> parameters) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);

    String path = "query/${query.name}/results";

    return http.get(path, uriParameters).then((response) => new QueryResult(response, _decode(response)));
  }

  Future<QueryResult> runQuery(Query query, Map<String, String> parameters) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);

    String path = "submit";

    return http.post(path, JSON.encode(query.bean), uriParameters).then((response) => new QueryResult(response, _decode(response)));
  }
  
  dynamic _decode(String json) {
    try {
      return JSON.decode(json);
    } catch(e) {
      throw new ErrorResponse(-1, "Failed parsing response", "Response: $json");
    }
  }

  Map<String, String> _getQueryParameters(Query query, Map<String, String> parameters) {
    Map<String, String> uriParameters = {};
    for (String queryParameter in query.parameters) {
      if (!parameters.containsKey(queryParameter)) throw new ArgumentError("Parameters missing " + queryParameter + " value");
      uriParameters[queryParameter] = parameters[queryParameter];
    }
    return uriParameters;
  }


  Future<bool> putQuery(Query query) {
    return http.post("queries", JSON.encode(query.bean)).then((response) => true);
  }

  Future<bool> deleteQuery(Query query) {
    return http.delete("query/${query.name}").then((response) => true);
  }
}
