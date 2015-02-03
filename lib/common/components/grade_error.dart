
import 'package:polymer/polymer.dart';

@CustomTag("grade-error")
class GradeError extends PolymerElement {

  @published
  String one;
  
  @published
  String two;

  @published
  String three;

  
  @observable
  int level=1;
  
  GradeError.created() : super.created();
  
  void ready() {
    onPropertyChange(this, #one, (){level=1;});
  }

  levelUp() {
    level++;
  }
  
  

  
}
