import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import '../../common.dart';

@CustomTag("grade-input")
class GradeInput extends PolymerElement {
  
  @published
  String value;
  
  @published
  String label;
  
  @published
  bool multiline;
  
  @published
  String inputValue;
  
  @published
  bool disabled;
  
  @published
  bool required;
  
  @published
  bool invalid;
  
  @published
  ValidationResult validation;
  
  PaperInput input;
  
  GradeInput.created() : super.created();
  
  void ready() {
    input = $["input"];
    onPropertyChange(this, #validation, _syncValidation);
  }
  
  void _syncValidation() {
    if (validation!=null) {
      input.invalid = !validation.isvalid;
      //TODO setCustomValidity takes a number, wait for package update input.setCustomValidity(validation.message);
    }
  }
  
}