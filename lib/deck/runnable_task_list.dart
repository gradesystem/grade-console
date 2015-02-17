part of deck;

@CustomTag("runnable-task-list") 
class RunnableTaskList extends GradeList {

  KeywordFilterFunction itemFilter = (EditableModel<Task> item, String term) 
                                =>  !item.newModel && !item.edit && 
                                    item.model.label != null && 
                                    item.model.label.toLowerCase().contains(term.toLowerCase());
  
  RunnableTaskList.created() : super.created('list') {
    setupKeywordFilter(itemFilter, false);
  }
  
  //we don't want to sync selection from list to model
  void ready() {
    list = $['list'] as CoreList;
    
    onPropertyChange(listitems.data, #isEmpty, () {
      async((_)=>list.updateSize());
      
      if (list.data.isNotEmpty) {
        Map index = list.indexesForData(list.data.first);
        if (index['virtual']>=0) list.selectItem(index['virtual']);
      }
    });
   }
}
