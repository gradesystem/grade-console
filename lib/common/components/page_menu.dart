import 'package:polymer/polymer.dart';

@CustomTag('page-menu')
class PageMenu extends PolymerElement {
  
  PageMenu.created() : super.created();
  
  void onItemSelected(event, detail, target) {
    this.fire("menu-item-selected", detail:detail['item'].label);
  }
  
}
