part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends PolymerElement {
  
  TasksPage.created() : super.created();
  
  void domReady() {
    fire("area-ready");
  }
}

