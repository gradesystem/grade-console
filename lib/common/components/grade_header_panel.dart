import 'package:polymer/polymer.dart';

@CustomTag("grade-header-panel")
class GradeHeaderPanel extends PolymerElement {
  
  @published
  String paneltitle;
  
  @published
  String panelsubtitle;
  
  @published
  bool fixedmain;
  
  GradeHeaderPanel.created() : super.created();
  
  bool get hideFooter => this.querySelectorAll('[footer]').isEmpty;
  
}