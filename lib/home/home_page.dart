part of home;

@CustomTag("home-page") 
class HomePage extends PolymerElement with Dependencies {
 
  HomePage.created() : super.created() {
    
    prod = instanceOf(ProdDatasets);
    prod_stats = new PageStatistics(prod.data.length,new DateTime.now(), []);
  
    stage = instanceOf(StageDatasets);
    stage_stats = new PageStatistics(stage.data.length,new DateTime.now(), []);
    
    tasks= instanceOf(Tasks);
    tasks_stats = new PageStatistics(tasks.data.length,new DateTime.now(), []);
    
    //todo
    deck_stats = new PageStatistics(0,new DateTime.now(), []);
  }

  @observable
  ProdDatasets prod;
  
  @observable
  StageDatasets stage;
 
  @observable
  Tasks tasks;
  
  @observable
  PageStatistics prod_stats;
  
  @observable
  PageStatistics stage_stats;
  
  @observable
  PageStatistics tasks_stats;
  
  @observable
  PageStatistics deck_stats;
  
  
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
  ontasksChange() {
      
        tasks_stats.loaded=!tasks.loading;
        tasks_stats.count=tasks.data.length;
        tasks_stats.date= new DateTime.now();
            
  }
  
  @ObserveProperty('tasks.loading') 
  ondeckChange() {
      
    deck_stats.loaded=!tasks.loading;
    deck_stats.date= new DateTime.now();
            
  }
}
