import 'package:polymer/polymer.dart';

@CustomTag('page-menu')
class PageMenu extends PolymerElement {
 
 final String selection_event = "page-selected"; 
 final String page_attribute = "page";
      
 PageMenu.created() : super.created();
  
  void notifyPageChange(event, detail, target) {
    this.fire(selection_event, detail:int.parse(target.attributes[page_attribute]));
  }
  
}
