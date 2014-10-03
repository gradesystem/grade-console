part of repo;

@CustomTag("graph-details") 
class GraphDetails extends Polybase with Filters {
  
  GraphDetails.created() : super.createWith(Storage);
  
  Storage get storage => model as Storage;

}