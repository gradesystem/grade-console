part of queries;

@CustomTag("query-list") 
class QueryList extends GradeList {
  
  ListFilter servicesFilter = new ListFilter("PUBLISHED", true, (EditableQuery item)=>(item.model.status == Query.K.status_published));
  ListFilter internalFilter = new ListFilter("UNPUBLISHED", true, (EditableQuery item)=>(item.model.status == Query.K.status_unpublished && !item.model.isSystem));
  ListFilter invalidFilter = new ListFilter("INVALID", false, (EditableQuery item)=>!item.valid && item.model.isPublished, true, true);
  ListFilter systemFilter = new ListFilter("SYSTEM", false, (EditableQuery item)=>(item.model.isSystem));
  ListFilter dataSystemFilter = new ListFilter("DATA", true, (EditableModel item)=>!item.model.isSystem);
  ListFilter underEditAlwaysVisibleFilter = new ListFilter.hidden((EditableModel item)=>item.edit, false);
  
  @published
  bool statusEditEnabled;
  
  KeywordFilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => Filters.containsIgnoreCase(item.model.name, term)
                    || Filters.containsIgnoreCase(item.model.get(Query.K.expression), term)
                    || Filters.containsIgnoreCase(item.model.status, term);
  
  QueryList.created() : super.created('list') {
     
    setupKeywordFilter(itemFilter);
  }
  
  void ready() {
    super.ready();
    filters.addAll(statusEditEnabled?[servicesFilter, internalFilter, invalidFilter, systemFilter, underEditAlwaysVisibleFilter]
    :[dataSystemFilter, systemFilter, underEditAlwaysVisibleFilter]);
  }
}
