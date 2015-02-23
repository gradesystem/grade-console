part of queries;

@CustomTag("query-list") 
class QueryList extends GradeList {
  
  ListFilter servicesFilter = new ListFilter("PUBLISHED", true, (EditableQuery item)=>(item.model.status == Query.K.status_published) && item.valid);
  ListFilter internalFilter = new ListFilter("UNPUBLISHED", true, (EditableQuery item)=>(item.model.status == Query.K.status_unpublished && !item.model.isSystem && item.valid));
  ListFilter invalidFilter = new ListFilter("INVALID", true, (EditableQuery item)=>!item.valid);
  ListFilter systemFilter = new ListFilter("SYSTEM", false, (EditableQuery item)=>(item.model.isSystem && item.valid));
  ListFilter dataSystemFilter = new ListFilter("DATA", true, (EditableModel item)=>!item.model.isSystem && item.valid);
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
    :[dataSystemFilter, invalidFilter, systemFilter, underEditAlwaysVisibleFilter]);
  }
}
