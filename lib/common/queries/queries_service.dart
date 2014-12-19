part of queries;

class QueryService extends EditableListService<Query> {
  
  static String SUBMIT_PATH = "submit";
  
  String base_url;

  QueryService(String base_url, String path) : super(path, "queries", "query", (Map json) => new Query.fromBean(base_url, path, json)){
    this.base_url = base_url;
  }

  Future<String> runQueryByName(Query query, Map<String, String> parameters, [RawFormat format=RawFormat.JSON]) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);

    String path = "query/${query.name}/results";

    return http.get(path, parameters:uriParameters, acceptedMediaType: format.value);
  }

  Future<String> runQuery(Query query, Map<String, String> parameters, [RawFormat format=RawFormat.JSON]) {

    Map<String, String> uriParameters = _getQueryParameters(query, parameters);
    
    //tmp workaround to limit the result size
    Map bean = new Map.from(query.bean);
    
    if (bean[Query.K.expression]!=null && !(bean[Query.K.expression] as String).contains("limit"))
       bean[Query.K.expression] = bean[Query.K.expression]+ " limit 1000";

    return http.post(SUBMIT_PATH, JSON.encode(bean), acceptedMediaType: format.value, parameters:uriParameters);
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
