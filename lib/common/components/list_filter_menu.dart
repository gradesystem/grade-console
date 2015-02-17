library list_filter;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag("list-filter-menu")
class ListFilterMenu extends PolymerElement {
  
  @published
  ObservableList<ListFilter> filters;
  
  @published
  bool disabled;
  
  onlyVisible(ObservableList filters) => filters == null || filters.isEmpty ? filters : toObservable(filters.where((ListFilter filter)=>filter.visible).toList());

  ListFilterMenu.created() : super.created();

  void onTap(Event event, detail, target) {
    String index = target.attributes['filter-index'];
    int filterIndex = int.parse(index);
    onlyVisible(filters)[filterIndex].active = !filters[filterIndex].active;
    fire('filter-updated');
  }
  
}

class ListFilter extends Observable {
  
  String label;
  
  @observable
  bool active;
  
  FilterFunction function;
  
  bool visible;
  
  bool exclusive;
  
  ListFilter(this.label, this.active, this.function, [this.visible = true, this.exclusive = false]);
  
  ListFilter.hidden(FilterFunction function, bool exclusive):this(null, true, function, false, exclusive);

  bool accept(dynamic item) => function(item);
  
}

typedef bool FilterFunction(dynamic item);
