import 'package:polymer/polymer.dart';
import 'package:grade_console/common.dart';

@CustomTag("grade-table")
class GradeTable extends View {
  
  @published
  List<List<String>> data;
  
  @published
  List<String> headers;
  
  @published
  bool disabled;
  
  GradeTable.created() : super.created();
  
  

  
}
