part of queries;

abstract class QueryService extends EditableListService<Query> {
  
  static String SUBMIT_PATH = "submit";

  QueryService(String path) : super(path, "queries", "query", (Map json) => new Query.fromBean(path, json));

  Future<QueryResult> runQueryByName(Query query, Map<String, String> parameters) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);

    String path = "query/${query.name}/results";

    return http.get(path, uriParameters).then((response) => new QueryResult(response, _decode(response)));
  }

  Future<QueryResult> runQuery(Query query, Map<String, String> parameters) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);

    return http.post(SUBMIT_PATH, JSON.encode(query.bean), acceptedMediaType:MediaType.SPARQL_JSON, parameters:uriParameters).then((response) => new QueryResult(response, _decode(response)));
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

  Future<bool> deleteQuery(Query query) {
    return delete(query);
  }
}
