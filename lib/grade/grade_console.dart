part of grade;



@CustomTag(GradeConsole.name)
class GradeConsole extends PolymerElement with Dependencies, Filters {

  List<Page> pages = [new Page("Grade", "Home", "home"), new Page("Linked Data", "Data", "prod"), new Page("Control Deck", "Deck", "deck"), new Page("Task Catalogue", "Tasks", "tasks"), new Page("Sources", "Sources", "stage")];

  static const name = "grade-console";

  @observable int page = 0;

  @observable
  bool creditsDialogOpened = false;
  
  @observable
  bool versionDialogOpen = false;

  @observable
  bool showLoadingProgress = false;

  @observable
  bool instantiateConsole = false;

  @observable
  int progressValue = 0;

  @observable
  String progressMessage = "loading home...";

  @observable
  List<bool> instantiateAreas = toObservable([false, false, false, false]);
  int nextArea = 0;

  CoreResizer resizer;

  GradeConsole.created() : super.created() {
    resizer = new CoreResizer(this);

    history.registerRoot(pages[0].tab, () {
      page = 0;
    });

    for (int i = 0; i < pages.length; i++) history.register(pages[i].tab, () {
      page = i;
    });

    onPropertyChange(this, #page, onPageChange);

    bus.on(PolymerReady).listen((_) {
      log.info("initializing console element, showing progress loader...");
      showLoadingProgress = true;
      new Timer(new Duration(milliseconds: 500), () {
        progressMessage = "loading home...";
        instantiateConsole = true;
      });
    });
    
    bus.on(ApplicationNewVersionAvailable).listen((_){
      versionDialogOpen = true;
    });
    
    onPropertyChange(this, #page, notifyResize);
  }

  void notifyResize() {
    Element targetContainer = (this.shadowRoot.querySelector("#pagescontainer") as CorePages).items[page];
    var target = targetContainer.querySelector("[on-area-ready]");
    async((_)=>resizer.notifyResize(target));
  }

  void attached() {
    super.attached();
    resizer.resizerAttachedHandler();
  }

  void detached() {
    super.detached();
    resizer.resizerDetachedHandler();
  }

  void onAreaReady(event, detail, target) {

    if (nextArea >= instantiateAreas.length) {
      progressValue = 100;
      progressMessage = "";
      new Timer(new Duration(milliseconds: 500), () {
        showLoadingProgress = false;
        bus.fire(const ApplicationInitialized());
      });
    } else {
      progressMessage = "loading " + pages[nextArea + 1].tab.toLowerCase() + "...";
      progressValue += 20;

      new Timer(new Duration(milliseconds: 500), () {
        instantiateAreas[nextArea++] = true;
      });
    }
  }

  void changePage(Event e, String tilename) {

    e.stopPropagation();

    switch (tilename) {

      case 'Linked Data':
        page = 1;
        break;
      case 'Control Deck':
        page = 2;
        break;
      case 'Task Catalogue':
        page = 3;
        break;
      case 'Source Data':
        page = 4;
        break;
      default:
        throw new ArgumentError("unknown tile $tilename");

    }
  }

  void onPageChange() {
    Page page = pages[this.page];
    history.go(page.tab, page.name);
  }

  void showCredits() {
    creditsDialogOpened = true;
  }

}


class Page {

  final String name;
  final String tab;
  final String style;

  Page(this.name, this.tab, this.style);
}
