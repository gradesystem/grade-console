part of repo;

@CustomTag("repo-page") 
class RepoPage extends Polybase {
  
  RepoPage.created() : super.createWith(RepoPageModel);
  
  void refresh() {
    repoModel.loadAll();
  }
  
  RepoPageModel get repoModel => model as RepoPageModel;
  
  RepoGraphs get graphs => repoModel.storage;
  
}

@Injectable()
class RepoPageModel {
  
  RepoService service;
  RepoGraphs storage;
  
  RepoPageModel(this.service, this.storage,  EventBus bus) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData);
    
  }
  
  void _setData(List<Graph> graphs) {

    //simulate slowness
    new Timer(new Duration(seconds: 3), (){
      storage.data.clear();
      storage.data.addAll(graphs);
      storage.loading = false;
    });
    
  }
}

@Injectable()
class RepoGraphs extends Graphs {
  
}

