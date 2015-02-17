part of deck;

@CustomTag("running-task-list") 
class RunningTaskList extends GradeList {
  
  KeywordFilterFunction itemFilter = (RunningTask item, String term) 
                                =>  item.execution.task.label != null && 
                                    (item.execution.task.label.toLowerCase().contains(term.toLowerCase())
                                     || 
                                     item.execution.status.toLowerCase().contains(term.toLowerCase()));

  RunningTaskList.created() : super.created('list') {
    setupKeywordFilter(itemFilter, false);
  }
}
