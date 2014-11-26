library deck;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';

import 'package:core_elements/core_list_dart.dart';

import 'common.dart';
import 'common/lists/lists.dart';
import 'common/editables/editables.dart';

import 'tasks.dart';


part 'deck/deck_page.dart';
part 'deck/deck_service.dart';
part 'deck/deck_model.dart';
part 'deck/runnable_tasks_panel.dart';
part 'deck/runnable_task_list.dart';
part 'deck/runnable_task_details_summary.dart';
part 'deck/running_tasks_panel.dart';

final Logger log = new Logger('grade.deck');

init() {
  
  var module = new Module()
          ..bind(DeckPageModel);

  
  Dependencies.add(module);
}
