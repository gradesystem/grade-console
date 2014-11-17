import 'package:polymer/polymer.dart';

@CustomTag("endpoint-dropdown-menu")
class EndpointDropdownMenu extends PolymerElement {
  
  @published
  String selected;
  
  @published
  List items;
  
  @published
  String label;
  
  @published
  bool disabled;
  
  @published
  bool required;
  
  @published
  ItemLabelProvider itemLabelProvider;
  
  @published
  ItemIdProvider itemIdProvider;
  
  EndpointDropdownMenu.created() : super.created();
  
  String itemLabel(item) => itemLabelProvider!=null?itemLabelProvider(item):item;
  String itemId(item) => itemIdProvider!=null?itemIdProvider(item):item;
  
}

typedef String ItemLabelProvider(item);

typedef String ItemIdProvider(item);