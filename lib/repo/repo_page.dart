part of repo;

@CustomTag("repo-page") 
class RepoPage extends Polybase {
  RepoPage.created() : super.createWith(RepoPageModel);
}

@Injectable()
class RepoPageModel {
  
  RepoService service;
  Graphs storage;
  
  RepoPageModel(this.service, this.storage,  EventBus bus) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    service.getAll().then((List<Graph> graphs) {storage.data = toObservable(graphs);});
    storage.loading = false;
  }
}

