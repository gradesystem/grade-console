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
  
  @observable
  bool creditsDialogOpened = false;
  

  @observable
  bool showLoadingProgress = false;
  
  @observable
  bool instantiateConsole = false;
  
  @observable
  int progressValue = 0;
  
  @observable
  String progressMessage = "loading home...";
  
  @observable
  List<bool> instantiateAreas = toObservable([false,false,false,false]);
  int nextArea = 0;
  
  GradeConsole.created() : super.created() {
    history.registerRoot(pages[0].tab, (){page=0;});
       for (int i = 0; i<pages.length; i++) history.register(pages[i].tab, (){page=i;});
       
       onPropertyChange(this, #page, onPageChange);
       
      bus.on(PolymerReady).listen((_) {
        log.info("initializing console element, showing progress loader...");
        showLoadingProgress = true;
        new Timer(new Duration(milliseconds: 500), () {
          progressMessage = "loading home...";
          instantiateConsole = true;
        });
      });
  }
  
  void onAreaReady(event, detail, target) {

    if (nextArea >= instantiateAreas.length) {
      progressValue = 100;
      progressMessage = "ready!";
      new Timer(new Duration(milliseconds: 500), () {
        showLoadingProgress = false;
        bus.fire(const ApplicationInitialized());
      });
    } else {
      progressMessage = "loading "+pages[nextArea+1].name+"...";
      progressValue +=20;
      
      new Timer(new Duration(milliseconds: 500), () {
        instantiateAreas[nextArea++] = true;
      });
    }
  }
  
  void changePage(Event e, String tilename) {
     
      e.stopPropagation();
      
      switch(tilename) {
        
            case 'Linked Data': page = 1; break;
            case 'Control Deck': page = 2; break;
            case 'Task Catalogue': page = 3; break;
            case 'Source Data':page = 4; break;
            default :
               throw new  ArgumentError("unknown tile $tilename");
              
        }
   }
  
  void onPageChange() {
    Page page = pages[this.page];
    history.go(page.tab, page.name);
  }
  
  @observable
  int counter = 0;
  
  void showCredits() {
    creditsDialogOpened = true;
    counter = 0;
  }
  
  void onEaster() {
    counter++;
  }
  
  @ComputedProperty("counter")
  bool get easter => counter>6;
  
}


class Page {
  
  final String name;
  final String tab;
  final String style;
  
  Page(this.name, this.tab, this.style);
}