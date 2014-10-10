part of prod;

@CustomTag("prod-page") 
class ProdPage extends Polybase {
  
  ProdPage.created() : super.createWith(ProdPageModel);
  
  void refresh() {
    prodModel.loadAll();
  }
  
  ProdPageModel get prodModel => model as ProdPageModel;
  
  ProdDatasets get datasets => prodModel.storage;
  
}

@Injectable()
class ProdPageModel {
  
  ProdService service;
  ProdDatasets storage;
  
  ProdPageModel(this.service, this.storage,  EventBus bus) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData);
    
  }
  
  void _setData(List<Dataset> graphs) {

    //simulate slowness
    new Timer(new Duration(seconds: 3), (){
      storage.data.clear();
      storage.data.addAll(graphs);
      storage.loading = false;
    });
    
  }
}

@Injectable()
class ProdDatasets extends Datasets {
  
}

