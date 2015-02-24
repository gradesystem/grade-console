import 'package:polymer/polymer.dart';
import 'package:core_elements/core_menu.dart';
import 'package:paper_elements/paper_dropdown.dart';
import 'package:grade_console/common.dart';
import 'dart:html';

@CustomTag("grade-dropdown-menu")
class GradeDropdownMenu extends PolymerElement {

  @published
  String selected;

  @published
  String label;

  @published
  bool disabled;

  @published
  bool required = false;

  @published
  bool invalid = false;
  
  @published
  String selectedAttribute;

  @observable
  String errorMsg;
  
  @published
  List<Validator> validators = [];
  
  CoreMenu menu;
  PaperDropdown dropdown;
  
  Validator required_validator = ($) => $==null || $.isEmpty? "Please make a choice.":null;
  Validator unknown_validator;
    
  
  GradeDropdownMenu.created() : super.created();
  
  ready() {
    
    menu = $["menu"] as CoreMenu;
    dropdown = $["dropdownpanel"] as PaperDropdown;
    
    unknown_validator = (sel) => (!isItem(sel))? "Current value '${sel}' is no longer a valid choice.":null;    
   
    //observes for internal children changes (add or remove of items)
   new MutationObserver(($1,$2) {
        menu.jsElement.callMethod("updateSelected",[]);
        
        //forces to recalculate the dropdown size
        dropdown.shadowRoot.querySelector("#scroller").style.height = "";
        
        onModelChange();
      })
      .observe(this.parentNode, childList:true, subtree:true);
  }

  bool isItem(String val) {
    
    for (var item in this.querySelectorAll("[dropitem]")) 
       if (val == item.attributes['dropitem'])
          return true;
    
    return false;
  }
  
  @ObserveProperty("invalid")
  onInvalidUpdate() {
    if (invalid == null) onModelChange();
  }
  
  @ObserveProperty("selected")
  onModelChange() {
    
    List<Validator> validators = new List.from(this.validators);
      
    if (required)
        validators.add(required_validator);
    
    validators.add(unknown_validator);
        
     
    for (Validator validator in validators) {
        
        String result = validator(selected); 
        
        if (result!=null) {
         
          errorMsg = result;
         
          invalid = true;
          
          return;
        }
      
     }
    
    invalid = false;
  }
}
