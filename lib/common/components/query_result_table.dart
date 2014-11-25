import 'package:polymer/polymer.dart';

@CustomTag("query-result-table")
class QueryResultTable extends PolymerElement {

  @published
  List<String> headers;
  
  @published
  List<Map<String,String>> rows;
  
  @published
  bool dirty;
    
  QueryResultTable.created() : super.created();

}
