import 'package:talker_flutter/talker_flutter.dart';

class Logger {
  Logger._internal();

  factory Logger() => _instance;

  static final Logger _instance = Logger._internal();

  final Talker talker = TalkerFlutter.init();
}
