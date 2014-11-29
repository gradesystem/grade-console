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
    
  ResultPanel.created() : super.created();
  
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
