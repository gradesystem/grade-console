part of queries;

abstract class QueryService extends ListService<Query> {
  
  QueryService(String path):super(path, "queries", (Map json) => new Query(path,json));

}