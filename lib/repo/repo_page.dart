part of repo;

@CustomTag("repo-page") 
class RepoPage extends PolymerElement with Dependencies {
  
  Duration TIMEOUT = const Duration(seconds: 3);
  
  RepoService service;
  
  RepoPage.created() : super.created() {
    service = instanceOf(RepoService);
    
    new Timer(TIMEOUT, service.init);
  }
}

