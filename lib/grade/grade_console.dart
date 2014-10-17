part of grade;



@CustomTag(GradeConsole.name) 
class GradeConsole  extends PolymerElement with Dependencies, Filters {
 
  List<Page> pages = [new Page("Grade","Home", "home"),
                      new Page("Linked Data","Data", "prod"),
                      new Page("Control Deck","Deck", "deck"),
                      new Page("Task Catalogue","Tasks", "tasks"),
                      new Page("Sources","Sources", "stage")];
   
  static const name = "grade-console";
  
  @observable int page = 0;
  
  GradeConsole.created() : super.created();
  
  void changePage(Event e, String tilename) {
     
      e.stopPropagation();
      
      switch(tilename) {
        
            case 'Linked Data': page = 1; break;
            case 'Control Deck': page = 2; break;
            case 'Task Catalogue': page = 3; break;
            case 'Sources':page = 4; break;
            default :
               throw new  ArgumentError("unknown tile $tilename");
              
        }
   }
  
}


class Page {
  
  final String name;
  final String tab;
  final String style;
  
  Page(this.name, this.tab, this.style);
}