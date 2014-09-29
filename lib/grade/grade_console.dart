part of grade;



@CustomTag(GradeConsole.name) 
class GradeConsole  extends PolymerElement with Dependencies {
 
  static const name = "grade-console";
 
  @observable int page = 0;
  
  GradeConsole.created() : super.created();
  
  void changePage(Event e, home.PageTile tile) {
     
      e.stopPropagation();
      
      switch(tile.name) {
        
            case 'Repo': page = 1; break;
            case 'Deck': page = 2; break;
            case 'Tasks': page = 3; break;
            case 'Stage':page = 4; break;
        }
   }
  
}
