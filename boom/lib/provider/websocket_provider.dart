import 'dart:async';
import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/utils/native_web/native_web.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'websocket_provider.g.dart';

class Session {
  Session({required this.sid, required this.pid});
  String pid;
  String sid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}

@Riverpod(keepAlive: true)
class Ws extends _$Ws {
  var _websocketUrl = '';
  @override
  WebSocket build() {
    final deviceId = ref.watch(configureProvider).deviceId;
    _websocketUrl = ref.watch(configureProvider).websocketUrl;
    final url = Uri.parse('ws://$_websocketUrl/register?id=$deviceId');
    var ws = WebSocket(url);
    var timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      keeplive();
    });
    ref.onDispose(() {
      timer.cancel();
    });
    return ws;
  }

  void send(List<int> message) {
    state.send(message);
  }

  void setNew(String websocketUrl) {
    final deviceId = ref.watch(configureProvider).deviceId;
    _websocketUrl = websocketUrl;
    final url = Uri.parse('ws://$_websocketUrl/register?id=$deviceId');
    state = WebSocket(url);
  }

  void status(void Function(ConnectionState status) callback) {
    state.connection.listen((status) {
      callback(status);
    });
  }

  void listen(Function(List<int>) callback) {
    state.messages.listen((event) {
      convertToBytes(event, callback);
    });
  }

  void keeplive() {
    send(Body(type: Type.keepalive).writeToBuffer());
  }

  String getUrl() {
    return _websocketUrl;
  }
}
