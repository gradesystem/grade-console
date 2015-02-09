import 'package:polymer/polymer.dart';
import 'package:grade_console/common/queries/queries.dart';

@CustomTag("result-breadcrumb")
class ResultBreadcrumb extends PolymerElement {
  
  @published
  ResultHistory history;
  
  ResultBreadcrumb.created() : super.created();
  
  void onCrumbClick(event,detail,target) {
    String index = target.attributes['crumb-index'];
    fire("go-crumb", detail:index);
  }
  
  String label(Crumb crumb) => crumb is DescribeCrumb?crumb.uri:"path:";
  
}
