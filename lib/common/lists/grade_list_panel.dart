part of lists;

@CustomTag("grade-list-panel") 
class GradeListPanel extends PolymerElement with Filters {
  
  @observable
  String kfilter='';
  
  @published
  String title;
  
  @published
  ListItems listitems;
  
  GradeListPanel.created() : super.created();
  
  void refresh() {
    fire("refresh");
  }
  
}