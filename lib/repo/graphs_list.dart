part of repo;

@CustomTag("graphs-list") 
class GraphsList extends Polybase with Dependencies {
  
  GraphsList.created() : super.createWith(Storage);
  
  void onItemSelected(CustomEvent event) {
    storage.selected = event.detail.data;
  }
  
  Storage get storage => model as Storage;
  
}