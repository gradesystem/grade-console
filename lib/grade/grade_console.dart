part of grade;



@CustomTag(GradeConsole.name) 
class GradeConsole  extends PolymerElement with Dependencies, Filters {
 
  List<Page> pages = [new Page("Grade","Home"),
                      new Page("Repository","Repo"),
                      new Page("Deck","Deck"),
                      new Page("Catalogue","Tasks"),
                      new Page("Staging","Stage")];
   
  static const name = "grade-console";
  
/*  var _mySyntax = new PolymerExpressions(globals: {
      'appName': 'My App',
    });

    DocumentFragment instanceTemplate(Element template) =>
        template.createInstance(this, _mySyntax);*/

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
  
  Page(this.name, this.tab);
}