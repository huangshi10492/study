import 'dart:async';
import 'dart:io';
import 'package:boom/utils/platform.dart';
import 'package:boom/widget/dialog/bool_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class WindowWatcher extends StatefulWidget {
  final Widget child;

  const WindowWatcher({
    required this.child,
    super.key,
  });

  @override
  State<WindowWatcher> createState() => _WindowWatcherState();

  static void closeWindow(BuildContext context) {
    final state = context.findAncestorStateOfType<_WindowWatcherState>();
    state?.onWindowClose();
  }
}

class _WindowWatcherState extends State<WindowWatcher>
    with WindowListener, TrayListener {
  static Stopwatch s = Stopwatch();

  @override
  Widget build(BuildContext context) {
    s.start();
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    initTray();
    windowManager.addListener(this);
    trayManager.addListener(this);
    if (isDesktop) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await windowManager.setPreventClose(true);
      });
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    if (!isDesktop) {
      return;
    }
    var result = await boolDialog('退出', '关闭程序，或者最小化到托盘？', '退出', '最小化到托盘');
    if (result != null && result) {
      exit(0);
    } else {
      await windowManager.hide();
    }
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    await showFromTray();
  }

  @override
  Future<void> onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    final entry =
        TrayEntry.values.firstWhereOrNull((e) => e.name == menuItem.key);
    switch (entry) {
      case TrayEntry.open:
        await showFromTray();
        break;
      case TrayEntry.hide:
        await windowManager.hide();
        break;
      case TrayEntry.close:
        exit(0);
      default:
    }
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }
}

enum TrayEntry {
  open,
  hide,
  close,
}

Future<void> initTray() async {
  trayManager
      .setIcon(isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png');
  final items = [
    MenuItem(
      key: TrayEntry.open.name,
      label: 'open',
    ),
    MenuItem(
      key: TrayEntry.hide.name,
      label: 'hide',
    ),
    MenuItem(
      key: TrayEntry.close.name,
      label: 'close',
    ),
  ];
  await trayManager.setContextMenu(Menu(items: items));
  await trayManager.setToolTip('boom');
}

Future<void> showFromTray() async {
  await windowManager.show();
  await windowManager.focus();
}
