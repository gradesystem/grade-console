import 'package:polymer/polymer.dart';

@CustomTag("grade-dropdown")
class GradeDropdown extends PolymerElement {
  
  @published
  String selected;
  
  @published
  List<String> items;
  
  @published
  String label;
  
  @published
  bool disabled;
  
  GradeDropdown.created() : super.created();
}