import 'package:polymer/polymer.dart';
import 'package:grade_console/common.dart';

@CustomTag("grade-error")
class GradeErrorElement extends PolymerElement {

  @published
  String one;
  
  @published
  String two;

  @published
  String three;
  
  @published
  GradeError error;

  @observable
  int level=1;
  
  GradeErrorElement.created() : super.created();
  
  void ready() {
    onPropertyChange(this, #one, (){level=1;});
    onPropertyChange(this, #error, (){
      level=1;
      one = error.title;
      two = error.description;
      three = error.details;
    });
  }

  levelUp() {
    level++;
    fire("level-up");
  }
  
}
