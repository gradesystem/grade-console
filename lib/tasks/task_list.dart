part of tasks;

@CustomTag("task-list")
class TaskList extends GradeList {
  
  ListFilter publishFilter = new ListFilter("PUBLISH", true);
  ListFilter addFilter = new ListFilter("ADD", true);
  ListFilter removeFilter = new ListFilter("REMOVE", true);

  FilterFunction itemFilter = (EditableModel<Task> item, String term) 
      => Filters.containsIgnoreCase(item.model.label, term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.transform), term) || 
          Filters.containsIgnoreCase(item.model.get(Task.K.diff), term);
  
  applyFilters(List<ListFilter> filters, _) => (List items) {
      
      return toObservable(items.where((EditableTask item) {
        return item.edit 
            || (publishFilter.active && item.model.operation == Operation.PUBLISH)
            || (addFilter.active && item.model.operation == Operation.ADD)
            || (removeFilter.active && item.model.operation == Operation.REMOVE);
      }).toList());
    };

  TaskList.created() : super.created('list') {
    filters.addAll([publishFilter, addFilter, removeFilter]);
  }
}
