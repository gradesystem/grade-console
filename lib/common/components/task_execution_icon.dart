import 'package:polymer/polymer.dart';
import '../../tasks.dart';

@CustomTag("task-execution-icon")
class TaskExecutionIcon extends PolymerElement {
  
  static TaskExecutionKeys K = const TaskExecutionKeys();
  static Map<String,String> icons = {K.status_submitted : "cloud-upload", 
                       K.status_started : "cloud",
                       K.status_transformed : "cloud",
                       K.status_modified : "cloud",
                       K.status_completed:"cloud-done",
                       K.status_failed:"warning"};

  @published
  String status;
 
  TaskExecutionIcon.created() : super.created();

  @ComputedProperty("status")
  String get icon => status!=null?icons[status]:"";

}
