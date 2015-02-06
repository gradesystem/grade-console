import 'package:polymer/polymer.dart';

@CustomTag("list-panel")
class ListPanel extends PolymerElement {
  
  @published
  bool loading; 
  
  @published
  bool empty;
  
  @published
  String emptyMessage = "Ops.. We've found no items";
  
  ListPanel.created() : super.created();  
}