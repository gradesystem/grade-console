part of deck;

@CustomTag("deck-page") 
class DeckPage extends Polybase {
  
  
  DeckPage.created() : super.createWith(DeckPageModel);

  void domReady() {
    fire("area-ready");
  }

  @observable
  DeckPageModel get deckModel => model as DeckPageModel;
  
  EditableTask asEditableTask(Task task) => task!=null?new EditableTask(task):null;
  Task getTask(RunningTask running) => running!=null?running.task:null;
  
  @ComputedProperty('deckModel.storage.selected.task.label')
  String get title {
    
    try {
      
      return "Results for '${deckModel.storage.selected.task.label}'";
    }
    on NoSuchMethodError {
      return "(no run selected)";
    }      
  }
  void set title(String drop){}
  
  void onDescribeUri(event, detail, target) {
    String type = detail["type"];
    RunningTask runningTask = detail["runningTask"];
    Crumb crumb = detail["crumb"];
    _retrieveResult(type, runningTask, crumb);
  }
  
  void onLoadResult(event, detail, target) {
    String type = detail["type"];
    RunningTask runningTask = detail["runningTask"];
    _retrieveResult(type, runningTask);
  }
  
  void _retrieveResult(String type, RunningTask runningTask, [Crumb crumb]) {
    switch(type) {
      case "transform": deckModel.retrieveTransformResult(runningTask, crumb); break;
      case "diff": deckModel.retrieveDifferenceResult(runningTask, crumb); break;
      case "target": deckModel.retrieveTargetResult(runningTask, crumb); break;
    }
  }
}
