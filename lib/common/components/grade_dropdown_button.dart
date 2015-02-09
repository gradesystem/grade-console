import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_dropdown_menu.dart';
import 'package:core_elements/core_menu.dart';
import 'package:grade_console/common.dart';
import 'dart:html';

@CustomTag("grade-dropdown-button")
class GradeDropdownButton extends PolymerElement {
  
  @published
  bool disabled;
  
  @published
  var selected;
  
  @published
  String selectedAttribute;
  
  @observable
  bool opened = false;

  GradeDropdownButton.created() : super.created();

  
}
