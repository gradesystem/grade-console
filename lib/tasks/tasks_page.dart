part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends ResizerPolymerElement {
  
  TasksPage.created() : super.created();
  
  void domReady() {
    fire("area-ready");
  }
}

