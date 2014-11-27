part of deck;

@CustomTag("deck-page") 
class DeckPage extends Polybase {
  
  
  DeckPage.created() : super.createWith(DeckPageModel);

  DeckPageModel get deckModel => model as DeckPageModel;
  
  EditableTask asEditableTask(Task task) => task!=null?new EditableTask(task):null;
  Task getTask(RunningTask running) => running!=null?running.execution!=null?running.execution.task:running.launchedTask:null;
  
}
