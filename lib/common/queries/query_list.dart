part of queries;

@CustomTag("query-list") 
class QueryList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (EditableModel<Query> item, String term) 
                    => item.model.get(Query.name_field) != null && 
                       item.model.get(Query.name_field).toLowerCase().contains(term.toLowerCase());
  
  QueryList.created() : super.created();
  
  void ready() {
    list = $['list'] as CoreList;
    list.data.changes.listen((_){selecteFirstItem();});
  }
  
  void selecteFirstItem() {
    if (list.data != null && list.data.isNotEmpty) {
      
      list.selectItem(0);
      //we are not notified about the selection
      listitems.selected = list.selection;
    }
  }
  
  void selectDataset(event) {
    listitems.selected = event.detail.data;
  }
  
  void removeItem(event, detail, target) {
    listitems.data.remove(detail);
  }
 
}
