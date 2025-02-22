import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:boom/proto/info.pb.dart';
import 'package:boom/proto/info.pbserver.dart';
import 'package:boom/provider/clipboard_provider.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/persistence_provider.dart';
import 'package:boom/provider/server_provider.dart';
import 'package:boom/provider/signaling_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/router.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/utils/uri.dart';
import 'package:boom/widget/dialog/nano_dialog.dart';
import 'package:boom/widget/window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isWindows) {
    await windowManager.ensureInitialized();
  }

  final persistenceService = await PersistenceService.initialize();
  runApp(
    ProviderScope(
      overrides: [
        persistenceServiceProvider.overrideWithValue(persistenceService),
      ],
      child: const MyApp(),
    ),
  );
  if (isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isWeb) {
      final appLinks = AppLinks();
      appLinks.uriLinkStream.listen((uri) {
        var publicInfo = uri2PublicInfo(uri.toString());
        if (publicInfo != null) {
          ref.read(signalingProvider.notifier).invite(
                Device(
                  deviceId: publicInfo.deviceId,
                  deviceName: "waiting",
                  deviceType: DeviceType.unknown.name,
                  publicKey: publicInfo.publicKey,
                ),
              );
        } else {
          nanoDialog("错误", "参数错误");
        }
      });
    }

    if (ref.read(configureProvider).startServerAlways) {
      try {
        ref.read(serverProvider.notifier).startServerFromSettings();
      } catch (e) {
        log(e.toString());
      }
    }
    return _MainWidget(
      child: MaterialApp.router(
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          fontFamily: isWindows ? "微软雅黑" : null,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
          fontFamily: isWindows ? "微软雅黑" : null,
        ),
        scrollBehavior: const MaterialScrollBehavior(),
        routerConfig: router,
        builder: OneContext().builder,
      ),
    );
  }
}

class _MainWidget extends StatelessWidget {
  final Widget child;
  const _MainWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return WindowWatcher(
        child: ClipboardWidget(child: child),
      );
    } else if (!isWeb) {
      return ClipboardWidget(child: child);
    } else {
      return child;
    }
  }
}
