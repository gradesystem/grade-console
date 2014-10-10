part of grade;



@CustomTag(GradeConsole.name) 
class GradeConsole  extends PolymerElement with Dependencies, Filters {
 
  List<Page> pages = [new Page("Grade","Home", "home"),
                      new Page("Repository","Repo", "prod"),
                      new Page("Deck","Deck", "deck"),
                      new Page("Catalogue","Tasks", "tasks"),
                      new Page("Staging","Stage", "stage")];
   
  static const name = "grade-console";
  
  @observable int page = 0;
  
  GradeConsole.created() : super.created();
  
  void changePage(Event e, String tilename) {
     
      e.stopPropagation();
      
      switch(tilename) {
        
            case 'Repository': page = 1; break;
            case 'Deck': page = 2; break;
            case 'Tasks': page = 3; break;
            case 'Staging':page = 4; break;
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