part of endpoints;

@CustomTag("endpoint-list") 
class EndpointList extends GradeList {
  
  ListFilter dataFilter = new ListFilter("DATA", true);
  ListFilter systemFilter = new ListFilter("SYSTEM", true);
  ListFilter lockedFilter = new ListFilter("LOCKED", true);
  
  FilterFunction itemFilter = (EditableModel<Endpoint> item, String term) 
                    => item.model.name != null && 
                       item.model.name.toLowerCase().contains(term.toLowerCase());
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
      
      return toObservable(items.where((EditableEndpoint item) {
        return item.edit 
            || (lockedFilter.active && item.model.locked)
            || (dataFilter.active && item.model.isData)
            || (systemFilter.active && item.model.isSystem);
      }).toList());
    };
  
  EndpointList.created() : super.created('list') {
    filters.addAll([dataFilter, systemFilter, lockedFilter]);
  }

}
