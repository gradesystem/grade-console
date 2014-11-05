
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:grade_console/common.dart';

@CustomTag("grade-input")
class GradeInput extends PolymerElement {
  
  @published
  String value;
  
  @published
  String inputValue;
  
  @published
  bool multiline;
  
  @published
  String label;
  
  @published
  bool required=false;
  
  @published
  bool disabled=false;
  
  @published
  bool invalid=false;
  
  @published
  List<Validator> validators = [];
  
  //hides low-level access
  @observable
  PaperInput get inner => this.$["input"] as PaperInput;
  
  
  void set error(String e) {
    inner.jsElement.callMethod('setCustomValidity', [e]); //fixed in later versions
  }
  
 
  Validator missing_validator = ($) => $==null || $.isEmpty? "Please fill in this field.":null;

  
  GradeInput.created() : super.created();
  
  
  
  
  
  @ObserveProperty('inputValue') 
  onModelChange() {
    
    List<Validator> validators = new List.from(this.validators);
    
    if (required)
      validators.add(missing_validator);
      
   
    for (Validator validator in validators) {
      
      String result = validator(inputValue); 
      
      if (result!=null) {
       
        error = result;
       
        //twofold effect, two corrects underlying bugs: 
        //1) for multiline, forces hiding of errors if disabled
        //2) for monoline, forces erros if disabled
        invalid = !disabled;
        
        return;
      }
    
    }
   
    error='';
   
  }
  
  @ObserveProperty('disabled') 
  onDisabled() {
    
    //recompute erros to compensate for underlying sync flaws
    onModelChange();

  }
  
  
    
}