import 'package:polymer/polymer.dart';
import 'package:core_elements/core_selector.dart';
import "dart:html";

@CustomTag('grade-selector')
class GradeSelector extends PolymerElement {

  @published
  String valueattr;

  @published
  bool multi;

  @published
  List selected;
  
  @published
  String selectedAttribute;
  
  @published
  bool notap;

  @observable
  var internalSelected;
  
  @observable
  var target;

  GradeSelector.created() : super.created();

  void ready() {
    
    internalSelected = multi?toObservable([]):null;
    
    $["selector"].selected = internalSelected;

    onPropertyChange(this, #selected, _syncInternalSelection);

    if (selected is ObservableList) {
      (selected as ObservableList).listChanges.listen((_) {_syncInternalSelection();});
    }
    
    //observes for internal children changes (add or remove of items)
    new MutationObserver(($1,$2) {
           ($["selector"] as CoreSelector).jsElement.callMethod("updateSelected",[]);
         })
         .observe(this.parentNode, childList:true, subtree:true);    
  }

  void _syncInternalSelection() {
    if (multi) {
      internalSelected.clear();
      if (selected!=null) internalSelected.addAll(selected);
    } else internalSelected = selected!=null && selected.isNotEmpty?selected.first:null;
  }

  void onCoreSelect() {
    if (selected!=null) {
      selected.clear();
      if (multi) selected.addAll(internalSelected);
      else if (internalSelected!=null) selected.add(internalSelected);
    }
  }

}
