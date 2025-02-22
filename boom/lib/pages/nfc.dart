import 'package:boom/proto/info.pb.dart';
import 'package:boom/router.dart';
import 'package:boom/utils/uri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCPage extends ConsumerStatefulWidget {
  const NFCPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NFCPageState();
}

class NFCPageState extends ConsumerState<NFCPage> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC写入')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NFC未启动: ${ss.data}'))
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        constraints: const BoxConstraints.expand(),
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: Text(result),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GridView.count(
                        padding: const EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          ElevatedButton(
                            child: const Text('获取数据'),
                            onPressed: () async {
                              var res = await context
                                  .push<Public?>(publicQrcodeScanPath);
                              if (res != null) {
                                setState(() {
                                  result = publicInfo2Uri(res);
                                });
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: _ndefWrite,
                            child: const Text('NFC写入'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        setState(() {
          result = '写入失败';
        });
        NfcManager.instance.stopSession(errorMessage: result);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createUri(Uri.parse(result)),
      ]);

      try {
        await ndef.write(message);
        setState(() {
          result = '写入完成';
        });
        NfcManager.instance.stopSession();
      } catch (e) {
        setState(() {
          result = e.toString();
        });
        NfcManager.instance.stopSession(errorMessage: result);
        return;
      }
    });
  }
}
