part of queries;

@CustomTag("query-list") 
class QueryList extends GradeList {
  
  ListFilter servicesFilter = new ListFilter("SERVICES", true);
  ListFilter internalFilter = new ListFilter("INTERNAL", true);
  ListFilter systemFilter = new ListFilter("SYSTEM", false);
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => Filters.containsIgnoreCase(item.model.name, term)
                    || Filters.containsIgnoreCase(item.model.get(Query.K.expression), term)
                    || Filters.containsIgnoreCase(item.model.status, term);
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
    return toObservable(items.where((EditableQuery item) {
      return item.edit 
          || (servicesFilter.active && item.model.status == Query.K.status_service)
          || (internalFilter.active && (item.model.status == Query.K.status_internal && !item.model.isSystem))
          || (systemFilter.active && item.model.isSystem);
    }).toList());
  };
  
  QueryList.created() : super.created('list') {
    filters.addAll([servicesFilter, internalFilter, systemFilter]);
  }
 
}
