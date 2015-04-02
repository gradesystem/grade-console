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
  
  bool isInverse(Crumb crumb) => crumb is DescribeCrumb && crumb.type == DescribeType.DESCRIBE_BY_OBJECT;
  
  label(int index)=>(Crumb crumb) {
    
    if (crumb is DescribeCrumb) {
      String uri = crumb.uri;
      if (index > 0) {
        Crumb prev = history.crumbs[index-1];
        if (prev is DescribeCrumb) {
          String prevUri = prev.uri;
          
          String commonPrefix = longestCommonPrefix([prevUri, uri]);

          if (commonPrefix.length>0 && commonPrefix!='${Uri.parse(uri).scheme}://') {
            String uriSuffix = uri.substring(commonPrefix.length);
            if (isInverse(crumb)) uriSuffix += " (B)";
            return "...$uriSuffix";
          }
        }
        
      } else return "start:";
      if (isInverse(crumb)) uri += " (B)";
      return uri;
    } else return "start:";
    
  };

  
  
}
