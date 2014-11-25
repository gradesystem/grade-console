library deck;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';

import 'common.dart';


part 'deck/deck_page.dart';
part 'deck/deck_service.dart';
part 'deck/deck_model.dart';

final Logger log = new Logger('grade.deck');

init() {
  
  var module = new Module()
          ..bind(DeckPageModel);

  
  Dependencies.add(module);
}
