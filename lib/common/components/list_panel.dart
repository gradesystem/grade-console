import 'package:polymer/polymer.dart';
import 'core_resizable.dart';

@CustomTag("list-panel")
class ListPanel extends PolymerElement {
  
  @published
  bool loading; 
  
  @published
  bool empty;
  
  @published
  String emptyMessage = "Ops.. We've found no items";
  
  CoreResizer resizer;
  
  ListPanel.created() : super.created() {
    resizer = new CoreResizer(this);
    
    onPropertyChange(this, #loading, (){
      resizer.notifyResize();
      
    });
  }
  
  void attached() {
    super.attached();
    resizer.resizerAttachedHandler();
  }
  
  void detached() {
    resizer.resizerDetachedHandler();
  }
  
}