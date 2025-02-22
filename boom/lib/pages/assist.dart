import 'package:boom/proto/info.pb.dart';
import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/security_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/router.dart';
import 'package:boom/utils/uri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AssistPage extends ConsumerStatefulWidget {
  const AssistPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AssistPageState();
}

class _AssistPageState extends ConsumerState<AssistPage> {
  List<Public> inviteList = [];
  List<Public> answerList = [];
  bool isrunning = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('协助连接'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (inviteList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("还没有添加连接方"),
                    ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: inviteList.length,
                    itemBuilder: (context, index) {
                      var invite = inviteList[index];
                      return ListTile(
                        title: Text(invite.deviceId),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            inviteList.removeAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      var res =
                          await context.push<Public?>(publicQrcodeScanPath);
                      if (res != null) {
                        inviteList.add(res);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("添加"),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.arrow_downward),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (answerList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("还没有添加被连接方"),
                    ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: answerList.length,
                    itemBuilder: (context, index) {
                      var answer = answerList[index];
                      return ListTile(
                        title: Text(answer.deviceId),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            answerList.removeAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      var res =
                          await context.push<Public?>(publicQrcodeScanPath);
                      if (res != null) {
                        answerList.add(res);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("添加"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: isrunning
            ? const CircularProgressIndicator()
            : const Icon(Icons.send),
        label: isrunning ? const Text("执行中") : const Text("执行"),
        onPressed: () {
          isrunning = true;
          List<String> data = [];
          for (var a in answerList) {
            data.add(publicInfo2Uri(a));
          }
          for (var l in inviteList) {
            var body = Body(
              type: Type.assist,
              to: l.deviceId,
              data: ref.read(securityProvider.notifier).encrypt(
                    AssistData(publicInfo: data).writeToJson(),
                    l.publicKey,
                  ),
            );
            ref.read(wsProvider.notifier).send(body.writeToBuffer());
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("执行完毕")));
          isrunning = false;
        },
      ),
    );
  }
}
