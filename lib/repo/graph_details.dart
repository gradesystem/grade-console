part of repo;

@CustomTag("graph-details") 
class GraphDetails extends Polybase {
  
 GraphDetails.created() : super.createWith(Graphs);
 
 @ComputedProperty('model.selected') 
 Graph get graph => readValue(#graph);
  
}