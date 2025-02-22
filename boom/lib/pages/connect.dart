import 'dart:io';

import 'package:boom/proto/info.pb.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/picker_provider.dart';
import 'package:boom/provider/signaling_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/router.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/utils/uri.dart';
import 'package:boom/widget/connect_appbar.dart';
import 'package:boom/widget/dialog/nano_dialog.dart';
import 'package:boom/widget/picker_list.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_handler/share_handler.dart';

class ConnectPage extends ConsumerStatefulWidget {
  const ConnectPage({super.key});

  @override
  ConsumerState<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends ConsumerState<ConnectPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _dragging = false;
  static const channel = MethodChannel("top.huangshi10492.boom/intent");
  getNFCData() async {
    String t = await channel.invokeMethod("intent");
    if (t != 'null') {
      var publicInfo = uri2PublicInfo(t);
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

  Future<void> handlerShare(SharedMedia media) async {
    final message = media.content;
    if (message != null && message.trim().isNotEmpty) {
      ref.read(pickerListProvider).add(Picker(PickerType.text)..data = message);
    } else if (media.attachments != null && media.attachments!.isNotEmpty) {
      List<Picker> pickerList = [];
      for (var e in media.attachments!) {
        if (e != null) {
          var p = Picker(PickerType.file)
            ..data = File(e.path).readAsBytesSync()
            ..label = e.path;
          pickerList.add(p);
        }
      }
      ref.read(pickerListProvider.notifier).add(pickerList);
    }
  }

  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    var media = await handler.getInitialSharedMedia();
    if (media != null) {
      handlerShare(media);
    }
    handler.sharedMediaStream.listen((SharedMedia media) {
      if (!mounted) return;
      handlerShare(media);
    });
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    if (isAndroid) {
      getNFCData();
      initPlatformState();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropTarget(
      onDragDone: (details) {
        for (var element in details.files) {
          var p = Picker(PickerType.file)
            ..data = element
            ..label = element.path;
          ref.read(pickerListProvider.notifier).add([p]);
        }
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const ConnectAppbarWidget(),
          actions: [
            Visibility(
              visible: isMobile,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      var res =
                          await context.push<Public?>(publicQrcodeScanPath);
                      if (res != null) {
                        ref.read(signalingProvider.notifier).invite(
                              Device(
                                deviceId: res.deviceId,
                                deviceName: "waiting",
                                deviceType: DeviceType.unknown.name,
                                publicKey: res.publicKey,
                              ),
                            );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.leak_add),
                    onPressed: () async {
                      context.push(assistPath);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PickerListWidget(),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.qr_code),
                        label: const Text("使用二维码连接"),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: QrImageView(
                                    data: publicInfo2Uri(
                                      Public(
                                        deviceId: ref
                                            .watch(configureProvider)
                                            .deviceId,
                                        publicKey: ref
                                            .watch(configureProvider)
                                            .publicKey,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...ref.watch(signalingProvider).entries.map(
                          (e) => e.value ?? const SizedBox(),
                        ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
            if (_dragging)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_download, size: 128),
                    const SizedBox(height: 30),
                    Text("放置文件", style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('发送'),
          onPressed: () {
            if (ref.read(pickerListProvider).isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('请添加数据')));
              return;
            }
            if (ref.read(signalingProvider).isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('请连接设备')));
              return;
            }
            ref.read(signalingProvider.notifier).sendPicker();
          },
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }
}
