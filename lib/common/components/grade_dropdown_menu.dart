import 'package:polymer/polymer.dart';

@CustomTag("grade-dropdown-menu")
class GradeDropdownMenu extends PolymerElement {

  @published
  String selected;

  @published
  String valueattr;

  @published
  String label;

  @published
  bool disabled;

  @published
  bool required = false;

  @published
  bool invalid = false;

  GradeDropdownMenu.created() : super.created();
  
  @ObserveProperty("selected")
  void updateInvalid() {
    invalid = required && (selected==null || selected.isEmpty);
  }

}
