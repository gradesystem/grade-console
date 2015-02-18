import 'package:polymer/polymer.dart';

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
