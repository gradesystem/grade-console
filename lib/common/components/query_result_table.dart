import 'package:polymer/polymer.dart';
import '../queries/queries.dart';

@CustomTag("query-result-table")
class QueryResultTable extends PolymerElement {
  
  @published
  QueryResult queryResult;
  
  @published
  bool dirty;
    
  QueryResultTable.created() : super.created();

}
