part of home;


@CustomTag("page-tile")
class PageTile extends PolymerElement with Filters {
  
  Map notificationsSets = {'error':'warning'};

  @published String name;
  @published String resource_name;

  @published bool areaEnabled = false;
  
  @published PageStatistics statistics;
  
  PaperProgress progress;
  
  PageTile.created() : super.created();
  
  void ready() {
    progress = $['progress'];
  }

  void tileSelected() {
    if (areaEnabled) this.fire("tile-selected", detail:name);
  }
  
  @ObserveProperty("statistics.loaded")
  void runProgress() {
    progress.value = progress.min;
    if (!statistics.loaded) {
      nextProgress(0);
    }
  }

  nextProgress(_) {
    if (progress.value < progress.max) {
      progress.value += (progress.step != 0 ? progress.step : 1);
    } else {
      progress.value = progress.min;
    }
    if (!statistics.loaded) window.animationFrame.then(nextProgress);
  }
}

class PageStatistics extends Observable {
  
  @observable
  int count;
  
  @observable
  DateTime date;
  
  @observable 
  bool loaded = false;
  
  @observable
  List<String> notifications = toObservable([]);
  
  PageStatistics(this.count, this.date);
}