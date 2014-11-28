part of deck;

@CustomTag("deck-page") 
class DeckPage extends Polybase {
  
  
  DeckPage.created() : super.createWith(DeckPageModel);

  @observable
  DeckPageModel get deckModel => model as DeckPageModel;
  
  EditableTask asEditableTask(Task task) => task!=null?new EditableTask(task):null;
  Task getTask(RunningTask running) => running!=null?running.task:null;
  
  @ComputedProperty('deckModel.storage.selected.execution.task.label')
  String get title {
    
    try {
      
      return "Results for '${deckModel.storage.selected.execution.task.label}'";
    }
    on NoSuchMethodError {
      return "(no run selected)";
    }      
  }
  void set title(String drop){}
}
