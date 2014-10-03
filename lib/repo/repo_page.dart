part of repo;

@CustomTag("repo-page") 
class RepoPage extends PolymerElement with Dependencies {
  
  RepoPageModel model;
  
  RepoPage.created() : super.created() {
    model = instanceOf(RepoPageModel);
  }
}


@Injectable()
class RepoPageModel {
  
  RepoService service;
  Storage storage;
  EventBus bus;
  
  RepoPageModel(this.service, this.storage, this.bus) {
    bus.on(ApplicationReady).listen((_) {
      init();
    });
  }
  
  void init() {
    storage.data = toObservable(service.getAll());
  }
}

