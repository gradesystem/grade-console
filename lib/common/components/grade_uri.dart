import '../../common.dart';
import 'package:polymer/polymer.dart';

@CustomTag("grade-uri")
class GradeUri extends PolymerElement with Filters {
  
  @published
  String value;
  
  GradeUri.created() : super.created();
  

  
}
