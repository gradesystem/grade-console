part of deck;

@CustomTag("deck-page") 
class DeckPage extends Polybase {
  
  
  DeckPage.created() : super.createWith(DeckPageModel);

  DeckPageModel get deckModel => model as DeckPageModel;
  TasksModel get tasks => deckModel.tasks;
}
