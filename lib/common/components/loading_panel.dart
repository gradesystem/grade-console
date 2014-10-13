import 'package:polymer/polymer.dart';

@CustomTag("loading-panel")
class LoadingPanel extends PolymerElement {

  @published
  bool loading;
  
  @published
  String message;
  
  LoadingPanel.created() : super.created();
  
}