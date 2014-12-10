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

    List<List<Map>> list = [];

    for (Map binding in qresult.rows) {
      List<Map> row = [];
      for (Map tuple in binding.values) row.add(tuple);

      list.add(row);
    }

    return list;
  }

}
