library list_filter;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag("list-filter-menu")
class ListFilterMenu extends PolymerElement {
  
  @published
  ObservableList filters;
  
  @published
  bool disabled;

  ListFilterMenu.created() : super.created();

  void onTap(Event event, detail, target) {
    String index = target.attributes['filter-index'];
    int filterIndex = int.parse(index);
    filters[filterIndex].active = !filters[filterIndex].active;
    fire('filter-updated');
  }
  
}

class ListFilter extends Observable {
  
  String label;
  
  @observable
  bool active;
  
  ListFilter(this.label, this.active);
  
}
