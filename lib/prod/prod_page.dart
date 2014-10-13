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
  
  EventBus bus;
  ProdService service;
  ProdDatasets storage;
  
  ProdPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData).catchError((e)=>_onError(e, loadAll));
    
  }
  
  void _setData(List<Dataset> graphs) {

    //simulate slowness
    new Timer(new Duration(seconds: 1), (){
      storage.data.clear();
      storage.data.addAll(graphs);
      storage.loading = false;
    });
    
  }
  
  
  void _onError(e, callback) {
    storage.data.clear();
    storage.loading = false;
    bus.fire(new ToastMessage.alert("Error: $e", callback));
  }
}

@Injectable()
class ProdDatasets extends Datasets {
  
}

