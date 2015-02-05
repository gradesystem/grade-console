import 'package:polymer/polymer.dart';
import 'package:core_elements/core_pages.dart';
import 'dart:html';
import 'core_resizable.dart';

@CustomTag('grade-subpages')
class GradeSubpages extends ResizerPolymerElement {
  
  static final page_attribute='page';
  
  @observable
  int subpage = 0;
  
  GradeSubpages.created() : super.created();
  
  void ready() {
    onPropertyChange(this, #subpage, notifyResize);
  }
  
  void notifyResize() {
    Element target = ($["#subpages"] as CorePages).items[subpage];
    resizer.notifyResize(target);
  }
  
  void changePage(Event event, int detail) {
    subpage = detail;
  }
  
}
