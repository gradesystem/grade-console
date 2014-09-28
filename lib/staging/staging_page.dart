part of staging;

@CustomTag(StagingPage.name) 
class StagingPage extends Polybase {
 
  static const name = "staging-page";
  
  StagingPage.created() : super.created();
  
  attached() {
    model.activate();
  }
}


@Injectable()
class StagingPageModel extends Object {
  
    EventBus bus;
    
    StagingPageModel(this.bus);
    
    activate() {
      
      bus.fire(const Activation());

    } 
}
