part of repo;

@CustomTag("graphs-list") 
class GraphsList extends PolymerElement with Dependencies {
  
  @observable GraphsListModel model;
  
  GraphsList.created() : super.created() {
    model = instanceOf(GraphsListModel);
  }
  
  void onItemSelected(CustomEvent event) {
    model.storage.selected = event.detail.data;
  }
  
}

@Injectable()
class GraphsListModel extends Object {
  
    Storage storage;
    
    GraphsListModel(this.storage);
}