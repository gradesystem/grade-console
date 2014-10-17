part of lists;

@CustomTag("grade-list-item") 
class GradeListItem extends PolymerElement with Filters {
  
  @published
  ListItem item;
  
  GradeListItem.created() : super.created();
  
}