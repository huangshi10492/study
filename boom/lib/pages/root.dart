import 'dart:convert';

import 'package:boom/pages/connect.dart';
import 'package:boom/pages/history.dart';
import 'package:boom/pages/settings.dart';
import 'package:boom/proto/info.pb.dart';
import 'package:boom/provider/signaling_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/theme.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/utils/uri.dart';
import 'package:boom/widget/dialog/nano_dialog.dart';
import 'package:boom/widget/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root.g.dart';

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() {
    return 0;
  }

  void update(int value) {
    state = value;
  }
}

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  final _pageController = PreloadPageController(initialPage: 0);

  static const List<NavigationDestination> tabs = [
    NavigationDestination(
      icon: Icon(Icons.connect_without_contact),
      label: '连接',
    ),
    NavigationDestination(
      icon: Icon(Icons.history),
      label: '历史',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings),
      label: '设置',
    ),
  ];

  void startNFC() async {
    if (isAndroid && await NfcManager.instance.isAvailable()) {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var data = Ndef.from(tag);
          if (data != null) {
            var records = (await data.read()).records;
            for (var recode in records) {
              var publicInfo =
                  uri2PublicInfo(utf8.decode(recode.payload.sublist(1)));
              if (publicInfo != null) {
                ref.read(signalingProvider.notifier).invite(Device(
                      deviceId: publicInfo.deviceId,
                      deviceName: "waiting",
                      deviceType: DeviceType.unknown.name,
                      publicKey: publicInfo.publicKey,
                    ));
              } else {
                nanoDialog("错误", "参数错误");
              }
            }
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startNFC();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (SizingInformation size) {
        return Scaffold(
          body: Row(children: [
            if (!size.isMobile)
              NavigationRail(
                selectedIndex: ref.watch(currentIndexProvider),
                onDestinationSelected: (value) =>
                    _goOtherTab(context, value, ref),
                extended: size.isDesktop,
                backgroundColor: Theme.of(context).cardColorWithElevation,
                labelType: size.isDesktop ? null : NavigationRailLabelType.all,
                leading: const Padding(padding: EdgeInsets.all(10)),
                destinations: tabs.map((tab) {
                  return NavigationRailDestination(
                    icon: tab.icon,
                    label: Text(
                      tab.label,
                    ),
                  );
                }).toList(),
              ),
            Expanded(
              child: SafeArea(
                left: size.isMobile,
                child: PreloadPageView(
                  controller: _pageController,
                  preloadPagesCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ConnectPage(),
                    HistoryPage(),
                    SettingsPage(),
                  ],
                ),
              ),
            ),
          ]),
          bottomNavigationBar: size.isMobile
              ? NavigationBar(
                  selectedIndex: ref.watch(currentIndexProvider),
                  onDestinationSelected: (value) =>
                      _goOtherTab(context, value, ref),
                  destinations: tabs,
                )
              : null,
        );
      },
    );
  }

  void _goOtherTab(BuildContext context, int index, WidgetRef ref) {
    if (index == ref.watch(currentIndexProvider)) return;

    ref.read(currentIndexProvider.notifier).update(index);

    _pageController.jumpToPage(index);
  }
}
