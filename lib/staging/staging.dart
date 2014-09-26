part of staging;

@CustomTag(StagingPage.name) 
abstract class StagingPage extends Polybase<StagingPageModel> {
 
  static const name = "staging-page";
  
  StagingPage.created() : super.created();
  
  attached() {
    model.activate();
  }
}


@Injectable()
class StagingPageModel {
  
    EventBus bus;
    
    StagingPageModel(this.bus);
    
    activate() {
      
      bus.fire(const Activation());

    } 
}
