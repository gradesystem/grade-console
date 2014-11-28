import 'package:polymer/polymer.dart';
import '../queries/queries.dart';

@CustomTag("result-panel")
class ResultPanel extends PolymerElement {

  @published
  Result result;
  
  @published
  bool dirty;
  
  @published
  String loadingMessage;
  
  @observable
  int format = 0;
    
  ResultPanel.created() : super.created();
  
  void toggleFormat() {
    format = ++format%2;
  }

}
