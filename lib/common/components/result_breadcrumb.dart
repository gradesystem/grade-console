import 'package:polymer/polymer.dart';
import 'package:grade_console/common/queries/queries.dart';

@CustomTag("result-breadcrumb")
class ResultBreadcrumb extends PolymerElement {
  
  @published
  ResultHistory history;
  
  ResultBreadcrumb.created() : super.created();
  
  void onUriClick(event,detail,target) {
    String index = target.attributes['uri-index'];
    fire("go-uri", detail:index);
  }
}
