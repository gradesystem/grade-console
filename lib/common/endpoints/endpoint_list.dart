part of endpoints;

@CustomTag("endpoint-list") 
class EndpointList extends GradeList {
  
  ListFilter dataFilter = new ListFilter("DATA", true, (EditableModel<Endpoint> item)=>item.model.isData);
  ListFilter systemFilter = new ListFilter("SYSTEM", true, (EditableModel<Endpoint> item)=>item.model.isSystem);
  ListFilter underEditAlwaysVisibleFilter = new ListFilter.hidden((EditableModel item)=>item.edit, false);
  
  KeywordFilterFunction itemFilter = (EditableModel<Endpoint> item, String term) 
                    => item.model.name != null && 
                       item.model.name.toLowerCase().contains(term.toLowerCase());
  
  EndpointList.created() : super.created('list') {
    filters.addAll([dataFilter, systemFilter, underEditAlwaysVisibleFilter]);
    setupKeywordFilter(itemFilter);
  }

}
