import 'package:polymer/polymer.dart';
import '../queries/queries.dart';

@CustomTag("query-result")
class QueryResultElement extends PolymerElement {

  @published
  QueryResult queryResult;
  
  @published
  bool dirty;
  
  @observable
  int format = 0;
    
  QueryResultElement.created() : super.created();
  
  void toggleFormat() {
    format = ++format%2;
  }

}
