part of grade;


@CustomTag(GradeConsole.name) 
class GradeConsole  extends PolymerElement with Dependencies {
 
  static const name = "grade-console";
 
  GradeConsoleModel model;
  
  @observable bool menubarVisible;
  
  GradeConsole.created() : super.created() {
    model = instanceOf(GradeConsoleModel);
    updateMenubarVisible();
  }
  
  void onAreaSelected(Event e, var details, Node target) {
      e.stopPropagation();
      
      model.toggleByName(details);
      updateMenubarVisible();
   }
  
  void updateMenubarVisible() {
    menubarVisible = model != null && model.page!=0; 
  }
}

@Injectable()
class GradeConsoleModel extends Observable {
  
  @observable int page = 0;
  
  toggle() {
    page = (page == 0) ? 1 : 0;
  }
  
  void toggleByName(String areaName) {
    switch(areaName) {
      case 'Home': page = 0; break;
      case 'Staging': page = 4; break;
    }
    
    
  }
}
