import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('grade-subpages')
class GradeSubpages extends PolymerElement {
  
  static final page_attribute='page';
  
  @observable
  int subpage = 0;
  
  GradeSubpages.created() : super.created();
  
  void changePage(Event event, int detail) {
    subpage = detail;
  }
  
}
