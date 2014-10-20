part of queries;

abstract class QueryService extends ListService<Query> {
  
  QueryService(String path):super(path, "queries", toQuery);

  static Query toQuery(Map json) {
    return new Query(json);
  }
}