part of deck;

@CustomTag("runnable-task-list") 
class RunnableTaskList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  CoreList list;
  
  FilterFunction itemFilter = (EditableModel<Task> item, String term) 
                                =>  !item.newModel && !item.edit && 
                                    item.model.label != null && 
                                    item.model.label.toLowerCase().contains(term.toLowerCase());

  CoreResizable resizable;
  
  RunnableTaskList.created() : super.created() {
    resizable = new CoreResizable(this);
  }
  
  void attached() {
    super.attached();
    resizable.resizableAttachedHandler((_)=>list.updateSize());
  }
   
  void detached() {
    super.detached();
    resizable.resizableDetachedHandler();
  }
  
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
