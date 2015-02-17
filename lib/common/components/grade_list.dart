library grade_list;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:grade_console/common.dart';
import 'package:grade_console/common/lists/lists.dart';
import 'package:core_elements/core_list_dart.dart';
import 'list_filter_menu.dart';
import 'core_resizable.dart';

class GradeList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ObservableList<ListFilter> filters = new ObservedItemList.from([]);
  
  @published
  ListItems listitems;
  
  @observable
  bool filtersUpdated = false;
  
  String listId;
  CoreList list;
  CoreResizable resizable;

  GradeList.created(this.listId) : super.created() {
    resizable = new CoreResizable(this);
    onPropertyChange(filters, #lastChangedItem, (){
          filtersUpdated = true;
        });
  }
  
  filter(_) {
    filtersUpdated = false;
    return (List items) => items == null || items.isEmpty ? items : toObservable(applyFilters(items)); 
  }
  
  applyFilters(List items) => items.where((item)=>applyExclusiveFilter(item) && applyOtherFilter(item)).toList();
  
  applyExclusiveFilter(dynamic item) => filters.where(exclusiveFilter).every((ListFilter filter)=>filter.accept(item));
  exclusiveFilter(ListFilter filter) => filter.active && filter.exclusive;
  
  applyOtherFilter(dynamic item) => filters.isNotEmpty ? filters.where(otherFilter).any((ListFilter filter)=>filter.accept(item)) : true;
  otherFilter(ListFilter filter) => filter.active && !filter.exclusive;
  
  void setupKeywordFilter(KeywordFilterFunction filter, [bool exclusive = true]) {
    ListFilter keywordFilter = new ListFilter.hidden((dynamic item)=>filter(item,kfilter), exclusive);
    filters.add(keywordFilter);
    onPropertyChange(this, #kfilter, (){
      filtersUpdated = true;
    });
  }
    
  void ready() {
    list = $[listId] as CoreList;

    //workaround to issue https://github.com/dart-lang/core-elements/issues/160
    Element viewport = list.shadowRoot.querySelector('#viewport');
    viewport.addEventListener('tap', (Event e){
      if ((e.path[0] as Element).localName == 'paper-icon-button') e.stopImmediatePropagation();
    });

    listitems.selection.listen(syncSelected);
    
    onPropertyChange(list, #selection, (){listitems.selected = list.selection;});
    
    onPropertyChange(listitems.data, #isEmpty, (){
      async((_)=>list.updateSize());
    });
  }
  
  void attached() {
    super.attached();
    resizable.resizableAttachedHandler((_)=>list.updateSize());

  }
   
  void detached() {
    super.detached();
    resizable.resizableDetachedHandler();
  }
  
  void syncSelected(SelectionChange change) {
    async((_) {
      var selected = change.selectFirst && list.data.isNotEmpty?list.data.first:change.item;
      if (selected != list.selection) {
        if (selected == null) list.clearSelection();
        else {
          Map index = list.indexesForData(selected);
          if (index['virtual']>=0) list.selectItem(index['virtual']);
        }
      }
    });
  }
}

typedef bool KeywordFilterFunction(dynamic item, String term);
