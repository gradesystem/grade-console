part of pages;

abstract class SubPageModel<T extends GradeEntity> {
  
  PageEventBus bus;
  ListService<T> service;
  ListItems<T> storage;
  
  SubPageModel(this.bus, this.service, this.storage) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }
 
  void loadAll() {
    storage.loading = true;
    storage.clearSelection();
    service.getAll()
    .then(_setData)
    .catchError((e)=>onError(e, loadAll))
    .whenComplete((){
      storage.loading = false;
    });
    
  }
  
  void _setData(List<T> items) {
    storage.setData(items, true);
  }
  
  void onError(e, callback) {
    storage.data.clear();
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}
