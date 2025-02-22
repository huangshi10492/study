import 'dart:io';

import 'package:boom/provider/configure_provider.dart';
import 'package:boom/utils/platform.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'persistence_provider.g.dart';

@Riverpod(keepAlive: true)
PersistenceService persistenceService(PersistenceServiceRef ref) {
  throw Exception('persistenceProvider not initialized');
}

class PersistenceService {
  final SharedPreferences prefs;

  PersistenceService._(this.prefs);

  static Future<PersistenceService> initialize() async {
    SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (isWindows) {
        final settingsDir = await path.getApplicationSupportDirectory();
        final prefsFile = p.join(settingsDir.path, 'shared_preferences.json');
        File(prefsFile).deleteSync();
        prefs = await SharedPreferences.getInstance();
      } else {
        throw Exception('Could not initialize SharedPreferences');
      }
    }
    await Configure.check(prefs);
    return PersistenceService._(prefs);
  }
}
