import 'package:event_bus/event_bus.dart';
import '../../common.dart';
import 'package:polymer/polymer.dart';

@CustomTag("grade-toast")
class GradeToast extends PolymerElement with Dependencies {
  
  @observable
  String text;
  
  @observable
  String role;
  
  @observable
  bool opened;
  
  @observable
  Function callback;

  GradeToast.created() : super.created()
  {
    EventBus bus = instanceOf(EventBus);
    bus.on(ToastMessage).listen(onToastMessage);
  }
  
  void onToastMessage(ToastMessage message) {
    
    text = message.message;
    role = message.type;
    callback = message.callback;
    
    opened = true;
  }
  
  void onRetry() {
   Function.apply(callback, []);
  }
  

  
}
