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
  
  @published
  bool uriDescribeEnabled = false;
    
  ResultPanel.created() : super.created();
  
  List toTable(ResulTable qresult) {

    List<List<Map>> list = [];

    for (Map<String, Map> binding in qresult.rows) {
      List<Map> row = [];
      for (String header in qresult.headers) {
        Map tuple = binding[header];
        if (tuple!=null) row.add(tuple);
        else row.add({});
      }

      list.add(row);
    }

    return list;
  }
  
  void onResultUriClick(event, detail, target) {
    Crumb crumb = result.history.go(detail);
    fire("eat-crumb", detail:crumb);
  }
  
  void onUriDescribe(event, detail, target) {
    Crumb crumb = result.history.go(detail, DescribeType.DESCRIBE_BY_OBJECT);
    fire("eat-crumb", detail:crumb);
  }
  
  void onResultGoCrumb(event, detail, target) {
    int index = int.parse(detail);
    Crumb crumb = result.history.goIndex(index);
    fire("eat-crumb", detail:crumb);
  }
}
