part of tasks;

@CustomTag("task-list")
class TaskList extends GradeList {
  
  ListFilter publishFilter = new ListFilter("PUBLISH", true, (EditableTask item)=>item.model.operation == Operation.PUBLISH);
  ListFilter addFilter = new ListFilter("ADD", true, (EditableTask item)=>item.model.operation == Operation.ADD);
  ListFilter removeFilter = new ListFilter("REMOVE", true, (EditableTask item)=>item.model.operation == Operation.REMOVE);
  ListFilter invalidFilter = new ListFilter("INVALID", false, (EditableTask item)=>!item.valid, true, true);
  ListFilter underEditAlwaysVisibleFilter = new ListFilter.hidden((EditableModel item)=>item.edit, false);
    
  KeywordFilterFunction itemFilter = (EditableModel<Task> item, String term) 
      => Filters.containsIgnoreCase(item.model.label, term) || 
         Filters.containsIgnoreCase(item.model.get(Task.K.transform), term) || 
         Filters.containsIgnoreCase(item.model.get(Task.K.diff), term);

  TaskList.created() : super.created('list') {
    filters.addAll([publishFilter, addFilter, removeFilter, invalidFilter, underEditAlwaysVisibleFilter]);
    setupKeywordFilter(itemFilter);
  }
}
