part of staging;

@Injectable()
class StagingService {

  final Logger _log = new Logger("staging-service");
  
  loadingthings(){
      _log.info("loading things with ${toString()}");
    }
  
  dothings(){
    _log.info("doing things with ${toString()}");
  }
}
