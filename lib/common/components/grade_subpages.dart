import 'package:polymer/polymer.dart';

@CustomTag('grade-subpages')
class GradeSubpages extends PolymerElement {
  
  @observable
  int subpage = 0;
  
  GradeSubpages.created() : super.created();
  
  void onMenuItemSelected(event, detail, target) {
    switch (detail) {
      case 'main': subpage = 0; break;
      case 'queries': subpage = 1; break;
    }
  }
  
}
