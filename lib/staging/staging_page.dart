part of staging;

@CustomTag("staging-page") 
class StagingPage extends Polybase {
  StagingPage.created() : super.createWith(StagingPageModel);
}

@Injectable()
class StagingPageModel {
}

