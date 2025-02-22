import 'package:boom/pages/nfc.dart';
import 'package:boom/pages/trusted_device.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/server_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/utils/ip.dart';
import 'package:boom/utils/logger.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/widget/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingList = [
      SettingsItem.titleItem(title: '一般'),
      SettingsItem.navigationItem(
        startIcon: Icons.devices,
        title: '信任设备列表',
        navigationWidget: const TrustDevicePage(),
      ),
      SettingsItem.switchItem(
        initialValue: ref.watch(configureProvider).clipboardListen,
        onChange: (value) {
          ref.read(configureProvider.notifier).changeClipboardListen(value);
        },
        startIcon: Icons.content_paste,
        title: '剪贴板监听',
        disvisible: isWeb,
      ),
      SettingsItem(
        startIcon: Icons.download,
        title: '下载目录',
        description: ref.watch(configureProvider).downloadPath,
        disvisible: isWeb,
        onPressed: (context) async {
          final directory = await FilePicker.platform.getDirectoryPath();
          if (directory != null) {
            ref.read(configureProvider.notifier).updateDownloadPath(directory);
          }
        },
      ),
      SettingsItem.navigationItem(
        startIcon: Icons.code,
        title: '日志',
        disvisible: isWeb,
        navigationWidget: TalkerScreen(
          appBarTitle: '日志',
          talker: Logger().talker,
          theme: TalkerScreenTheme.fromTheme(Theme.of(context)),
        ),
      ),
      SettingsItem.titleItem(
        title: 'nfc',
        disvisible: !isAndroid,
      ),
      SettingsItem.navigationItem(
        startIcon: Icons.nfc,
        navigationWidget: const NFCPage(),
        title: 'nfc写入',
        disvisible: !isAndroid,
      ),
      SettingsItem.titleItem(
        title: '网络',
        disvisible: isWeb,
      ),
      SettingsItem(
        startIcon: Icons.wifi_tethering,
        title: '注册中心配置',
        description: ref.read(configureProvider).websocketUrl,
        onPressed: (context) => signalingDialog(context, ref),
      ),
      SettingsItem(
        startIcon: Icons.sync_alt,
        title: '中转服务配置',
        description: ref.read(configureProvider).turnUrl,
        onPressed: (context) => turnDialog(context, ref),
      ),
      SettingsItem.switchItem(
        initialValue: ref.watch(configureProvider).startServerAlways,
        onChange: (value) {
          ref.read(configureProvider.notifier).changeStartServerAlways(value);
        },
        startIcon: Icons.play_arrow,
        title: '本地服务自启动',
        disvisible: isWeb,
      ),
      SettingsItem(
        startIcon: Icons.dns,
        title: '本地服务信息',
        onPressed: (context) => serverStatusDialog(context),
        disvisible: isWeb,
      ),
      SettingsItem(
        startIcon: Icons.miscellaneous_services,
        title: '本地服务配置',
        onPressed: (context) => servicesDialog(context, ref),
        disvisible: isWeb,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView.builder(
          itemCount: settingList.length,
          itemBuilder: (context, index) {
            return settingList[index];
          }),
    );
  }
}

void signalingDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      final url = ref.read(configureProvider).websocketUrl;
      final TextEditingController urlController =
          TextEditingController(text: url);
      return AlertDialog(
        title: const Text('注册中心配置'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            labelText: '注册中心地址',
            hintText: url,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消')),
          TextButton(
            onPressed: () {
              if (url != urlController.text && urlController.text != '') {
                ref
                    .read(configureProvider.notifier)
                    .updateWebsocketUrl(urlController.text);
                ref.read(wsProvider.notifier).setNew(urlController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}

void turnDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      final url = ref.read(configureProvider).turnUrl;
      final TextEditingController urlController =
          TextEditingController(text: url);
      return AlertDialog(
        title: const Text('中转服务配置'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            labelText: '中转服务地址',
            hintText: url,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消')),
          TextButton(
            onPressed: () {
              if (url != urlController.text && urlController.text != '') {
                ref
                    .read(configureProvider.notifier)
                    .updateTurnUrl(urlController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}

void serverStatusDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(builder: (context, ref, child) {
        return AlertDialog(
          title: const Text('服务信息'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ref.watch(serverProvider) == null) const Text('服务状态：关闭'),
              if (ref.watch(serverProvider) != null) ...[
                const Text('服务状态：开启'),
                Text('服务端口：${ref.watch(serverProvider)!.port}'),
                Builder(builder: (context) {
                  var port = ref.watch(configureProvider).port;
                  return FutureBuilder(
                      future: getIPs(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('服务地址：'),
                              ...snapshot.data!.map((e) => Text('$e:$port'))
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      });
                })
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  ref.read(serverProvider.notifier).restartServerFromSettings(),
              child: const Text('重启'),
            ),
            ref.watch(serverProvider) == null
                ? TextButton(
                    onPressed: () => ref
                        .read(serverProvider.notifier)
                        .startServerFromSettings(),
                    child: const Text('启动'),
                  )
                : TextButton(
                    onPressed: () =>
                        ref.read(serverProvider.notifier).stopServer(),
                    child: const Text('停止'),
                  ),
          ],
        );
      });
    },
  );
}

void servicesDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      int port = ref.read(configureProvider).port;
      final TextEditingController portController =
          TextEditingController(text: port.toString());
      return AlertDialog(
        title: const Text('服务配置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: portController,
              decoration: InputDecoration(
                labelText: '端口号',
                hintText: port.toString(),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消')),
          TextButton(
            onPressed: () {
              if (port != int.parse(portController.text) &&
                  portController.text != '') {
                ref
                    .read(configureProvider.notifier)
                    .updatePort(int.parse(portController.text));
                ref.read(serverProvider.notifier).restartServerFromSettings();
              }
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}
