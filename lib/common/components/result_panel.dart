import 'package:polymer/polymer.dart';
import '../queries/queries.dart';

@CustomTag("result-panel")
class ResultPanel extends PolymerElement {

  @published
  Result result;
  
  @published
  bool disabled;
  
  @published
  String loadingMessage;
  
  @published
  bool contentCopyEnabled;
  
  @published
  bool breadcrumbEnabled = true;
    
  ResultPanel.created() : super.created();
  
  List toTable(ResulTable qresult) {

    List<List<Map>> list = [];

    for (Map binding in qresult.rows) {
      List<Map> row = [];
      for (Map tuple in binding.values) row.add(tuple);

      list.add(row);
    }

    return list;
  }
  
  void onResultUriClick(event, detail, target) {
    result.history.go(detail);
    fire("describe-uri", detail:detail);
  }
  
  void onResultGoUri(event, detail, target) {
    int index = int.parse(detail);
    result.history.goIndex(index);
    if (!result.history.isQueryUrl) fire("describe-uri", detail:result.history.currentUri);
    else fire("run-query");
  }
}
