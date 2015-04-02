import 'package:polymer/polymer.dart';
import 'package:grade_console/common/queries/queries.dart';
import 'package:grade_console/common.dart';

@CustomTag("result-breadcrumb")
class ResultBreadcrumb extends PolymerElement {
  
  @published
  ResultHistory history;
  
  ResultBreadcrumb.created() : super.created();
  
  void onCrumbClick(event,detail,target) {
    String index = target.attributes['crumb-index'];
    fire("go-crumb", detail:index);
  }
  
  isInverse(Crumb crumb) => crumb is DescribeCrumb && crumb.type == DescribeType.DESCRIBE_BY_OBJECT;
  
  label(int index)=>(Crumb crumb) {
    
    if (crumb is DescribeCrumb) {
      String uri = crumb.uri;
      if (index > 0) {
        Crumb prev = history.crumbs[index-1];
        if (prev is DescribeCrumb) {
          String prevUri = prev.uri;
          print('prevUri $prevUri');
          
          String commonPrefix = longestCommonPrefix([prevUri, uri]);
          print('commonPrefix $commonPrefix');

          if (commonPrefix.length>0 && commonPrefix!='${Uri.parse(uri).scheme}://') {
            String uriSuffix = uri.substring(commonPrefix.length);
            return "...$uriSuffix";
          }
        }
        
      } else return "path:";
      return uri;
    } else return "path:";
    
  };
  
}
