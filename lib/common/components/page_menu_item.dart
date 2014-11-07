import 'package:polymer/polymer.dart';

@CustomTag('page-menu-item')
class PageMenuItem extends PolymerElement {
 
 final String selection_event = "page-selected"; 
 
 @published
 String label;
 
 @published
 String icon;
 
 @published
 int page;
 
 PageMenuItem.created() : super.created();
  
  void notifyPageChange(event, detail, target) {
    this.fire(selection_event, detail:page);
  }
  
}
