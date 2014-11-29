import 'package:polymer/polymer.dart';
import '../queries/queries.dart';

@CustomTag("query-result-table")
class QueryResultTable extends PolymerElement {
  
  @published
  QueryResult queryResult;
  
  @published
  bool dirty;
    
  QueryResultTable.created() : super.created();

  
  List toTable(QueryResult qresult) {
      
      List<List<String>> list = [];
      
      for (Map binding in qresult.rows) {
        List<String> row = [];
        for (Map tuple in binding.values)
          row.add(tuple['value']);
       
        list.add(row); 
      }
      
      return list;
   }
    
}
