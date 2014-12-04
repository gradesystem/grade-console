part of home;

@CustomTag("home-page") 
class HomePage extends PolymerElement with Dependencies {

  @observable
  Datasets prod;
  
  @observable
  Datasets stage;
 
  @observable
  Tasks tasks;
  
  @observable
  RunningTasks runningTasks;
  
  @observable
  PageStatistics prod_stats;
  
  @observable
  PageStatistics stage_stats;
  
  @observable
  PageStatistics tasks_stats;
  
  @observable
  PageStatistics deck_stats;
  
  HomePage.created() : super.created() {
    
    prod = instanceOf(Datasets, ProdAnnotation);
    prod_stats = new PageStatistics(prod.data.length,new DateTime.now());
  
    stage = instanceOf(Datasets, StageAnnotation);
    stage_stats = new PageStatistics(stage.data.length,new DateTime.now());
    
    tasks = instanceOf(Tasks);
    tasks_stats = new PageStatistics(tasks.data.length,new DateTime.now());

    runningTasks = instanceOf(RunningTasks);
    deck_stats = new PageStatistics(runningTasks.running.length,new DateTime.now());
  }
  
  
  @ObserveProperty('prod.loading') 
  @ObserveProperty('prod.data') 
  onProdChange() {
    
    prod_stats.loaded=!prod.loading;
    prod_stats.count=prod.data.length;
    prod_stats.date= new DateTime.now();
        
  }
  
  @ObserveProperty('stage.loading') 
  @ObserveProperty('stage.data') 
  onStageChange() {
      
    stage_stats.loaded=!stage.loading;
      stage_stats.count=stage.data.length;
      stage_stats.date= new DateTime.now();
          
  }
  
  @ObserveProperty('tasks.loading') 
  @ObserveProperty('tasks.data') 
  onTasksChange() {
      
        tasks_stats.loaded=!tasks.loading;
        tasks_stats.count=tasks.data.length;
        tasks_stats.date= new DateTime.now();
            
  }
  
  @ObserveProperty('runningTasks.loading') 
  @ObserveProperty('runningTasks.running') 
  @ObserveProperty('runningTasks.failed')
  onDeckChange() {
      
    deck_stats.loaded=!runningTasks.loading;
    deck_stats.count=runningTasks.running.length;
    deck_stats.date= new DateTime.now();
    
    deck_stats.notifications.clear();
    if (runningTasks.failed.isNotEmpty) deck_stats.notifications.add("error");   
  }
}
