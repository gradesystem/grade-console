import "package:polymer/polymer.dart";
import "package:core_elements/core_animation.dart";

import "dart:html";

@CustomTag("console-header") 
class ConsoleHeader extends PolymerElement {
  
  static const String FADE_IN = "fadein";
  static const String FADE_OUT = "fadeout";

  @observable bool menubarVisible;
  CoreAnimation fadeout;
  CoreAnimation fadein;
  bool isDomReady = false;
  
 
  ConsoleHeader.created() : super.created();
  
  void domReady() {
    isDomReady = true; 
    
    DivElement menuBar = $['menubar'];
    
    fadein = $[FADE_IN];
    fadein.target = menuBar;
        
    fadeout = $[FADE_OUT];
    fadeout.target = menuBar;
   
    animateMenuBar();    
  }
  
  void onMenuClick(Event e, var details, var target) {
    String name = target.attributes['data-area'];
    dispatchEvent(new CustomEvent("areaselected", detail:name));
  }
  
  void menubarVisibleChanged(o,v) {
    if (isDomReady) animateMenuBar();
  }
  
  void animateMenuBar() {
    if (menubarVisible) fadein.play();
    else fadeout.play();
  }

    
}