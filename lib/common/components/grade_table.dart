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
  
  GradeTable.created() : super.created();
  
  isUri(Map m) => m is Map && m != null && m['type'] == "uri";

  void uriClick(event, detail, target) {
    //we filter not clickable uri
    if (target.attributes['pointer']==null) return;
    fire("uri-click", detail:target.attributes['cell-value']);
  }
}
