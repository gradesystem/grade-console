import 'package:polymer/polymer.dart';

@CustomTag("grade-dropdown")
class GradeDropdown extends PolymerElement {
  
  @published
  String selected;
  
  @published
  List items;
  
  @published
  String label;
  
  @published
  bool disabled;
  
  @published
  ItemLabelProvider itemLabelProvider;
  
  @published
  ItemIdProvider itemIdProvider;
  
  GradeDropdown.created() : super.created();
  
  String itemLabel(item) => itemLabelProvider!=null?itemLabelProvider(item):item;
  String itemId(item) => itemIdProvider!=null?itemIdProvider(item):item;
  
  @ComputedProperty("selected")
  String get singleItemLabel {
    var item = items.firstWhere((e)=>itemId(e) == selected, orElse:()=>null);
    return item != null?itemLabel(item):null;
  }
  
}

typedef String ItemLabelProvider(item);

typedef String ItemIdProvider(item);