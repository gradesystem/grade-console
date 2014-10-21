part of pages;

abstract class PageModel<T extends ListItem> {
  
  EventBus bus;
  ListService<T> service;
  ListItems<T> storage;
  
  PageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData).catchError((e)=>_onError(e, loadAll));
    
  }
  
  void _setData(List<T> items) {

    storage.data.clear();
    storage.data.addAll(items);
    storage.loading = false;
    
  }
  
  
  void _onError(e, callback) {
    storage.data.clear();
    storage.loading = false;
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}