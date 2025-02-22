import 'dart:convert';

import 'package:boom/provider/signaling_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/utils/net/request_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_client/web_socket_client.dart';

enum ConnectType { connected, disconnect, connecting }

class ConnectAppbarWidget extends ConsumerStatefulWidget {
  const ConnectAppbarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectAppbarWidgetState();
}

class _ConnectAppbarWidgetState extends ConsumerState<ConnectAppbarWidget> {
  ConnectType websocketStatus = ConnectType.disconnect;
  void listenStatus() {
    ref.read(wsProvider.notifier).status((status) {
      setState(() {
        switch (status) {
          case Connecting _:
          case Disconnecting _:
            websocketStatus = ConnectType.connecting;
            break;
          case Connected _:
          case Reconnected _:
            websocketStatus = ConnectType.connected;
            break;
          case Disconnected _:
          case Reconnecting _:
            websocketStatus = ConnectType.disconnect;
            break;
          default:
            websocketStatus = ConnectType.disconnect;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("主页"),
        const SizedBox(width: 10),
        InkWell(child: Builder(
          builder: (context) {
            switch (websocketStatus) {
              case ConnectType.connecting:
                return const Icon(Icons.cloud_queue, color: Colors.yellow);
              case ConnectType.connected:
                return const Icon(Icons.cloud_done, color: Colors.green);
              case ConnectType.disconnect:
                return const Icon(Icons.cloud_off, color: Colors.red);
              default:
                return const SizedBox();
            }
          },
        ), onTap: () async {
          var result = await showDialog<bool?>(
            context: context,
            builder: (context) {
              return Consumer(builder: (context, ref, child) {
                return AlertDialog(
                  title: Builder(
                    builder: (context) {
                      switch (websocketStatus) {
                        case ConnectType.connecting:
                          return const Text("连接中...");
                        case ConnectType.connected:
                          return const Text("已连接");
                        case ConnectType.disconnect:
                          return const Text("未连接");
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                  content: FutureBuilder(
                    future: RequestManager.get(
                        'http://${ref.read(wsProvider.notifier).getUrl()}/info'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data != null) {
                        var data = jsonDecode(snapshot.data!.data);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('类型: ${data['type']}'),
                            if (data['type'] == '云端服务')
                              Text('ip: ${data['ip']}'),
                            Text('端口: ${data['port']}'),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('连接新的注册中心'),
                    )
                  ],
                );
              });
            },
          );
          if (result != null) {
            if (!context.mounted) {
              return;
            }
            var res = await showDialog<String?>(
              context: context,
              builder: (context) {
                var c = TextEditingController(
                    text: ref.read(wsProvider.notifier).getUrl());
                return Consumer(builder: (context, ref, child) {
                  return AlertDialog(
                    title: const Text('修改服务地址'),
                    content: TextField(
                      controller: c,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(c.text);
                        },
                        child: const Text('确定'),
                      )
                    ],
                  );
                });
              },
            );
            if (res != null) {
              ref.read(wsProvider.notifier).setNew(res);
              ref.read(signalingProvider.notifier).relisten();
              listenStatus();
            }
          }
        })
      ],
    );
  }
}
