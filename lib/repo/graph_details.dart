part of repo;

@CustomTag("graph-details") 
class GraphDetails extends PolymerElement with Dependencies, Filters {
  
  @observable
  DetailsModel model;
  
  GraphDetails.created() : super.created() {
    model = instanceOf(DetailsModel);
  }
  
}

@Injectable()
class DetailsModel {
  
  Storage storage;
  
  DetailsModel(this.storage);
  
  @observable
  Graph get graph => storage.selected;
}