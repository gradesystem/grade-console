library editables;

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:polymer/polymer.dart';
import 'package:event_bus/event_bus.dart';
import 'package:logging/logging.dart';

import '../../common.dart';
import '../lists/lists.dart';

part 'editables_model.dart';

part 'editables_service.dart';

final Logger log = new Logger('grade.editables');