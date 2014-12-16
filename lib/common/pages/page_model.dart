part of pages;

abstract class SubPageModel<T extends GradeEntity> {
  
  EventBus bus;
  ListService<T> service;
  ListItems<T> storage;
  
  SubPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll()
    .then(_setData)
    .catchError((e)=>_onError(e, loadAll))
    .whenComplete((){
      storage.loading = false;
    });
    
  }
  
  void _setData(List<T> items) {
    storage.setData(items, true);
  }
  
  void _onError(e, callback) {
    storage.data.clear();
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}
