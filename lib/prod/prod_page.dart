part of prod;

@CustomTag("prod-page") 
class ProdPage extends Polybase {
  
  @observable
  int subpage = 0;
  
  void onMenuItemSelected(event, detail, target) {
    switch (detail) {
      case 'datasets': subpage = 0; break;
      case 'queries': subpage = 1; break;
    }
  }
  
  ProdPage.created() : super.createWith(ProdPageModel);
  
  void refresh() {
    prodModel.loadAll();
  }
  
  ProdPageModel get prodModel => model as ProdPageModel;
  
  ProdDatasets get datasets => prodModel.storage;
  
}

@Injectable()
class ProdPageModel extends PageModel<Dataset> {
  ProdPageModel(EventBus bus, ProdService service, ProdDatasets storage) : super(bus, service, storage);
}

@Injectable()
class ProdDatasets extends Datasets {
  
}

