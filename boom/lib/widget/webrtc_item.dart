import 'dart:async';
import 'package:crypto/crypto.dart' as crypto;
import 'package:boom/proto/info.pb.dart';
import 'package:boom/proto/transport.pb.dart';
import 'package:boom/proto/transport.pbserver.dart';
import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/clipboard_provider.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/database/database.dart';
import 'package:boom/provider/security_provider.dart';
import 'package:boom/provider/server_provider.dart';
import 'package:boom/provider/signaling_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/utils/native_web/native_web.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/widget/dialog/copy_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:one_context/one_context.dart';

class WebRTCItemController {
  Function(AnswerData data)? answerHandler;
  Function(OfferData data)? offerHandler;
  Function(CandidateData data)? candidateHanlder;
  Function()? close;
  Function(List<int> file, String name)? sendFile;
  Function(String text, bool fromClipboard)? sendText;
}

class WebRTCItem extends ConsumerStatefulWidget {
  const WebRTCItem({
    super.key,
    required this.controller,
    required this.selfId,
    required this.sessionId,
    required this.isInvite,
    required this.deviceInfo,
    this.data,
  });
  final WebRTCItemController controller;
  final String selfId;
  final String sessionId;
  final Device deviceInfo;
  final bool isInvite;
  final OfferData? data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebRTCItemState();
}

class _WebRTCItemState extends ConsumerState<WebRTCItem> {
  var _inCalling = false;
  final _iceServers = {
    'iceServers': [],
  };
  var state = "";
  bool _waitAccept = false;
  final List<RTCIceCandidate> _candidateList = [];
  void Function(RTCIceCandidate candidate)? sendIceCandidate;
  late RTCPeerConnection pc;
  late RTCDataChannel dc;
  late Device _deviceInfo = widget.deviceInfo;
  Map<String, FileTransferState> fileTransferStateMap = {};
  bool _isConnected = false;

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };
  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };
  @override
  void initState() {
    super.initState();
    _iceServers['iceServers'] = [
      {
        'urls': 'turn:${ref.read(configureProvider).turnUrl}',
        'username': widget.selfId,
        'credential': widget.selfId
      }
    ];
    widget.controller.answerHandler = _onAnswer;
    widget.controller.offerHandler = _onOffer;
    widget.controller.candidateHanlder = _onCandidate;
    widget.controller.close = _close;
    widget.controller.sendFile = _sendFile;
    widget.controller.sendText = _sendText;
    if (widget.isInvite) {
      _invitePeer();
    } else {
      _onOffer(widget.data!);
    }
  }

  _invitePeer() async {
    await _createSession(
      peerId: widget.deviceInfo.deviceId,
    );
    _createDataChannel();
    _createOffer();
    _waitAccept = true;
  }

  Future<void> _closeSession() async {
    if (pc.connectionState != null &&
        pc.connectionState ==
            RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      await dc.close();
      await pc.close();
    }
    pc.dispose();
  }

  Future<void> _createSession({
    required String peerId,
  }) async {
    pc = await createPeerConnection({
      ..._iceServers,
    }, _config);

    pc.onIceCandidate = (candidate) {
      if (sendIceCandidate != null) {
        sendIceCandidate!(candidate);
      } else {
        _candidateList.add(candidate);
      }
    };
    pc.onConnectionState = (state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _isConnected = false;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _isConnected = false;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _isConnected = false;
        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          _isConnected = false;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          _isConnected = false;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _isConnected = true;
      }
      setState(() {});
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        _close();
      }
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(channel);
    };
  }

  void _addDataChannel(RTCDataChannel channel) {
    channel.onDataChannelState = (e) {
      setState(() {
        state = e.name;
      });
    };
    channel.onMessage = (RTCDataChannelMessage data) {
      setState(() {
        if (data.isBinary) {
          handleBinaryMessage(data.binary);
        } else {
          handleTextMessage(data.text);
        }
      });
    };
    dc = channel;
  }

  Future<void> _createDataChannel({label = 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 10;
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    _addDataChannel(channel);
  }

  Future<void> _createOffer() async {
    try {
      RTCSessionDescription s = await pc.createOffer(_dcConstraints);
      await pc.setLocalDescription(s);
      _send(
        Type.offer,
        OfferData(
          deviceInfo: Device(
            deviceId: ref.watch(configureProvider).deviceId,
            deviceName: await DeviceInfo.getDeviceName(),
            deviceType: (await DeviceInfo.getDeviceType()).name,
            publicKey: ref.read(configureProvider).publicKey,
          ).writeToJson(),
          sdp: s.sdp,
          media: 'data',
        ).writeToJson(),
      );
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _createAnswer() async {
    try {
      RTCSessionDescription s = await pc.createAnswer({
        'mandatory': {
          'OfferToReceiveAudio': false,
          'OfferToReceiveVideo': false,
        },
        'optional': [],
      });
      await pc.setLocalDescription(s);
      _send(
        Type.answer,
        AnswerData(
          sdp: s.sdp,
          deviceInfo: Device(
            deviceId: ref.watch(configureProvider).deviceId,
            deviceName: await DeviceInfo.getDeviceName(),
            deviceType: (await DeviceInfo.getDeviceType()).name,
            publicKey: ref.read(configureProvider).publicKey,
          ).writeToJson(),
        ).writeToJson(),
      );
    } catch (e) {
      //print(e.toString());
    }
  }

  _sendText(String text, bool fromClipboard) {
    dc.send(
      RTCDataChannelMessage(
        TextMessage(type: fromClipboard ? 'clip' : 'nano', content: text)
            .writeToJson(),
      ),
    );
  }

  _sendFile(List<int> file, String name) async {
    var md5 = crypto.md5.convert(file).toString();
    var size = file.length;
    var state = FileTransferState(name, size, true, '', md5);
    state.fileData = file;
    fileTransferStateMap[md5] = state;
    setState(() {});
    processSend(md5, 0);
  }

  Future<void> processSend(String md5, int nextChunk) async {
    int maxchunkSize = 200000;
    var state = fileTransferStateMap[md5];
    if (state == null) {
      return;
    }
    if (nextChunk >= state.size) {
      state.fileCompleted = true;
      return;
    }
    state.chunkStart = nextChunk;
    state.nextChunk = nextChunk + maxchunkSize > state.size
        ? state.size
        : nextChunk + maxchunkSize;
    var fileData = FileData(
      name: state.filename,
      md5: md5,
      size: state.size,
      chunkStart: nextChunk,
      chunk: state.fileData.sublist(nextChunk, state.nextChunk),
    );
    var bytes = fileData.writeToBuffer();
    dc.send(RTCDataChannelMessage.fromBinary(bytes));
    setState(() {});
  }

  handleBinaryMessage(List<int> bytes) async {
    var message = FileMessage.parse(bytes);
    if (fileTransferStateMap[message.data.md5] == null) {
      var savePath =
          "${ref.read(configureProvider).downloadPath}/${message.data.name}";
      if (isWindows) {
        savePath = savePath.replaceAll("/", "\\");
      }
      fileTransferStateMap[message.data.md5] = FileTransferState(
          message.data.name, message.data.size, false, savePath, message.md5);
    }
    fileTransferStateMap[message.data.md5]!
        .receiveQueue[message.data.chunkStart] = message;
    await processWrite(message.data.md5);
  }

  Future<void> processWrite(String md5) async {
    var state = fileTransferStateMap[md5]!;

    if (state.processing) {
      return;
    }
    state.processing = true;

    var message = state.receiveQueue[state.nextChunk];
    if (message == null) {
      state.processing = false;
      return;
    }

    await state.writeData(message.chunk);
    var writtenLength = message.data.chunkStart + message.chunk.length;

    state.fileCompleted = writtenLength == message.data.size;
    state.receiveQueue.remove(state.nextChunk);

    state.nextChunk = message.data.chunkStart + message.chunk.length;
    state.processing = false;
    setState(() {});
    dc.send(
      RTCDataChannelMessage(
        TextMessage(
          type: 'ack',
          content: FileAck(
            md5: md5,
            nextChunk: state.nextChunk,
          ).writeToJson(),
        ).writeToJson(),
      ),
    );
    if (!state.fileCompleted) {
      processWrite(md5);
    } else {
      if (!state.check()) {
        OneContext().showSnackBar(builder: (context) {
          return SnackBar(
            content: Text('${state.filename}文件校验失败'),
            duration: const Duration(seconds: 3),
          );
        });
        return;
      }
      state.complete();
      if (!isWeb) {
        // 文件接收完成
        ref.read(appDatabaseProvider).addHistory(
              HistoriesCompanion(
                type: const drift.Value('file'),
                title: drift.Value(state.filename),
                content: drift.Value(state.savePath),
                date: drift.Value(DateTime.now()),
              ),
            );
      }
    }
  }

  handleTextMessage(String message) {
    var data = TextMessage.fromJson(message);
    switch (data.type) {
      case 'clip':
        ref.read(clipboardLastTextProvider.notifier).state = data.content;
        Clipboard.setData(ClipboardData(text: data.content));
        OneContext().showSnackBar(
          builder: (context) {
            return const SnackBar(
              content: Text('已复制到剪贴板'),
              duration: Duration(seconds: 3),
            );
          },
        );
        break;
      case 'nano':
        copyDialog('收到文本', data.content);
        ref.read(appDatabaseProvider).addHistory(
              HistoriesCompanion(
                type: const drift.Value('text'),
                title: const drift.Value('文本'),
                content: drift.Value(data.content),
                date: drift.Value(DateTime.now()),
              ),
            );
        break;
      case 'ack':
        var ack = FileAck.fromJson(data.content);
        if (fileTransferStateMap[ack.md5] == null) {
          return;
        }
        processSend(ack.md5, ack.nextChunk);
        break;
      default:
    }
  }

  _onAnswer(AnswerData data) async {
    sendIceCandidate = (candidate) {
      _send(
        Type.candidate,
        CandidateData(
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ).writeToJson(),
      );
    };
    var connectInfo = Device.fromJson(data.deviceInfo);
    var device = await ref
        .read(trustedDeviceManagerProvider.notifier)
        .searchByDeviceId(connectInfo.deviceId);
    if (device == null) {
      return;
    }
    ref.read(trustedDeviceManagerProvider.notifier).updateInfo(
          device.index,
          device.id,
          connectInfo.deviceName,
          connectInfo.deviceType,
        );
    for (var candidate in _candidateList) {
      sendIceCandidate!(candidate);
    }
    pc.setRemoteDescription(RTCSessionDescription(data.sdp, 'answer'));
    if (_waitAccept) {
      _waitAccept = false;
    }
    setState(() {
      _inCalling = true;
      _deviceInfo = Device.fromJson(data.deviceInfo);
    });
  }

  _onOffer(OfferData data) async {
    sendIceCandidate = (candidate) {
      _send(
        Type.candidate,
        CandidateData(
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        ).writeToJson(),
      );
    };
    for (var candidate in _candidateList) {
      sendIceCandidate!(candidate);
    }
    await _createSession(peerId: widget.deviceInfo.deviceId);
    await pc.setRemoteDescription(RTCSessionDescription(data.sdp, 'offer'));
    _createAnswer();
    setState(() {
      _inCalling = true;
    });
  }

  _onCandidate(CandidateData data) async {
    RTCIceCandidate candidate =
        RTCIceCandidate(data.candidate, data.sdpMid, data.sdpMLineIndex);
    await pc.addCandidate(candidate);
  }

  _close() {
    ref.read(wsProvider.notifier).send(Body(
          type: Type.bye,
          sessionId: widget.sessionId,
          from: widget.selfId,
          to: widget.deviceInfo.deviceId,
        ).writeToBuffer());
    if (_waitAccept) {
      //print('peer reject');
      _waitAccept = false;
      Navigator.of(context).pop(false);
    }
    setState(() {
      _inCalling = false;
    });
    _closeSession();
    ref.read(signalingProvider.notifier).remove(widget.sessionId);
  }

  _send(Type type, String data) {
    var body = Body(
      type: type,
      data: ref.read(securityProvider.notifier).encrypt(
            data,
            widget.deviceInfo.publicKey,
          ),
      from: widget.selfId,
      to: widget.deviceInfo.deviceId,
      sessionId: widget.sessionId,
    ).writeToBuffer();
    ref.read(wsProvider.notifier).send(body);
    ref.read(serverProvider.notifier).send(widget.deviceInfo.deviceId, body);
  }

  @override
  Widget build(BuildContext context) {
    if (!_inCalling) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Expanded(
                child: Text('连接中...'),
              )
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  DeviceType.fromString(_deviceInfo.deviceType).icon,
                  size: 40,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text(
                          _deviceInfo.deviceName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.videocam),
                          onPressed: () {
                            ref
                                .read(signalingProvider.notifier)
                                .videoCall(_deviceInfo, false);
                          },
                          tooltip: '摄像头分享',
                        ),
                        IconButton(
                          icon: const Icon(Icons.screen_share),
                          onPressed: () {
                            ref
                                .read(signalingProvider.notifier)
                                .videoCall(_deviceInfo, true);
                          },
                          tooltip: '屏幕分享',
                        ),
                        IconButton(
                          onPressed: () => _close(),
                          tooltip: '断开连接',
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: fileTransferStateMap.entries.map((e) {
                        return InkWell(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      e.value.fileCompleted
                                          ? Icons.check_circle
                                          : Icons.hourglass_bottom,
                                      color: e.value.fileCompleted
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        e.value.filename,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: LinearProgressIndicator(
                                  value: e.value.fileCompleted
                                      ? 1
                                      : e.value.nextChunk / e.value.size,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (e.value.fileCompleted) {
                              e.value.complete();
                            } else {
                              if (e.value.isSender) {
                                processSend(e.value.md5, e.value.chunkStart);
                              } else {
                                processWrite(e.value.md5);
                              }
                            }
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
