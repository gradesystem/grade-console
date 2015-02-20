part of tasks;

@CustomTag("task-list")
class TaskList extends GradeList {
  
  ListFilter publishFilter = new ListFilter("PUBLISH", true, (EditableTask item)=>item.model.operation == Operation.PUBLISH && item.valid);
  ListFilter addFilter = new ListFilter("ADD", true, (EditableTask item)=>item.model.operation == Operation.ADD && item.valid);
  ListFilter removeFilter = new ListFilter("REMOVE", true, (EditableTask item)=>item.model.operation == Operation.REMOVE && item.valid);
  ListFilter invalidFilter = new ListFilter("INVALID", true, (EditableTask item)=>!item.valid);
  ListFilter underEditAlwaysVisibleFilter = new ListFilter.hidden((EditableModel item)=>item.edit, false);

  TaskList.created() : super.created('list') {
    filters.addAll([publishFilter, addFilter, removeFilter, invalidFilter, underEditAlwaysVisibleFilter]);
    setupKeywordFilter(filterTask);
  }
}
