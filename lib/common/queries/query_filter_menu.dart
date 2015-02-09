part of queries;

@CustomTag("query-filter-menu")
class QueryFilterMenu extends PolymerElement {
  
  @published
  ObservableList<QueryFilter> filters = new ObservedItemList.from([
                               new QueryFilter("services", true, (EditableModel<Query> item)=>item.model.status == Query.K.status_service),
                               new QueryFilter("internal", true, (EditableModel<Query> item)=>item.model.status == Query.K.status_internal),
                               new QueryFilter("predefined", false, (EditableModel<Query> item)=>item.model.predefined)
                               ]);
  
  @published
  bool disabled;

  QueryFilterMenu.created() : super.created();

  void onTap(event, detail, target) {
    String index = target.attributes['filter-index'];
    int filterIndex = int.parse(index);
    filters[filterIndex].active = !filters[filterIndex].active;
    fire('filter-updated');
  }
  
}

class QueryFilter extends Observable {
  
  String label;
  
  @observable
  bool active;
  
  var filter;
  
  QueryFilter(this.label, this.active, this.filter);
}
