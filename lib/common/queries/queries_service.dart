part of queries;

abstract class QueryService extends ListService<Query> {
  
  QueryService(String path):super(path, "queries", (Map json) => new Query.fromBean(path,json));
  
  Future<QueryResult> runQueryByName(Query query, Map<String, String> parameters) {
    
    Map<String,String> uriParameters = _getQueryParameters(query, parameters);
    
    Uri queryUri = new Uri.http("", "$service_url/query/${query.bean[Query.name_field]}/results", uriParameters);
    
    return http.getString(queryUri.toString()).then((json)=>new QueryResult(json, JSON.decode(json)));
  }
  
  Future<QueryResult> runQuery(Query query, Map<String, String> parameters) {
    
    Map<String,String> uriParameters = _getQueryParameters(query, parameters);
    
    Uri queryUri = new Uri.http("", "$service_url/submit", uriParameters);
    
    return http.postJSon(queryUri.toString(), JSON.encode(query.bean)).then((json)=>new QueryResult(json, JSON.decode(json)));
  }
  
  Map<String,String> _getQueryParameters(Query query, Map<String, String> parameters) {
       Map<String,String> uriParameters = {};
       for (String queryParameter in query.parameters) {
         if (!parameters.containsKey(queryParameter)) throw new ArgumentError("Parameters missing "+queryParameter+" value");
         uriParameters[queryParameter] = parameters[queryParameter];
       }
       return uriParameters;
  }

}