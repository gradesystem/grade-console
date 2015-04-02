import 'package:polymer/polymer.dart';
import 'package:grade_console/common.dart';

@CustomTag("grade-table")
class GradeTable extends View {
  
  @published
  List<List<Map>> data;
  
  @published
  List<String> headers;
  
  @published
  bool disabled;
  
  @published
  bool contentCopyEnabled = false;
  
  @published
  bool uriDescribeEnabled = true;
  
  GradeTable.created() : super.created();
  
  isUri(Map m) => m is Map && m != null && m['type'] == "uri";
  
  bool sawBefore(int rowIndex, int cellIndex) => rowIndex>0 && areLeftCellEquals(rowIndex, cellIndex);
  
  bool areLeftCellEquals(int rowIndex, int cellIndex) {
    for (int i = 0; i<cellIndex+1; i++) {
      if (data[rowIndex][i]['value'] != data[rowIndex-1][i]['value']) return false;
    }
    return true;
  }

  void uriClick(event, detail, target) {
    //we filter not clickable uri
    if (target.attributes['cell-type'] == "uri") fire("uri-click", detail:target.attributes['cell-value']);
  }
  
  void uriDescribe(event, detail, target) {
    //we filter not clickable uri
    if (target.attributes['cell-type'] == "uri") fire("uri-describe", detail:target.attributes['cell-value']);
  }
  
  void copyContent(event, detail, target) {
    fire("copy-content", detail:target.attributes['cell-value']);
  }
}
