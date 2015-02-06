import 'package:polymer/polymer.dart';
import 'package:core_elements/core_pages.dart';
import 'dart:html';
import 'core_resizable.dart';

@CustomTag('grade-subpages')
class GradeSubpages extends ResizerPolymerElement {
  
  static final page_attribute='page';
  
  @observable
  int subpage = 0;
  
  CorePages corePages;
  
  GradeSubpages.created() : super.created() {
    resizer.filter = (Element e) => e == corePages.selectedItem;
  }
  
  void ready() {
    corePages = $["subpages"] as CorePages;
  }
  
  void coreSelect(event, detail, target) {
    if (detail["isSelected"]) resizer.notifyResize(detail["item"]);
  }
  
  void changePage(Event event, int detail) {
    subpage = detail;
  }
  
}
