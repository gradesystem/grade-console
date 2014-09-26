import "package:polymer/polymer.dart";
import "dart:html";

@CustomTag("page-tile") 
class PageTile extends PolymerElement {
  
  @published String name;
 
  PageTile.created() : super.created();
  
  void onLinkClick(Event e, var details, Node target) {
    dispatchEvent(new CustomEvent("areaselected", detail:name));
  }
    
}