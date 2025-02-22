import 'package:boom/proto/info.pb.dart';
import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/picker_provider.dart';
import 'package:boom/provider/security_provider.dart';
import 'package:boom/provider/server_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/utils/uri.dart';
import 'package:boom/widget/webrtc_item.dart';
import 'package:boom/pages/webrtc_video.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

part 'signaling_provider.g.dart';

@Riverpod(keepAlive: true)
class Signaling extends _$Signaling {
  WebRTCVideoPage? _videoItem;
  @override
  Map<String, WebRTCItem?> build() {
    ref.read(wsProvider.notifier).listen(onMessage);
    ref.read(serverProvider.notifier).listen(onMessage);
    return {};
  }

  void relisten() {
    ref.read(wsProvider.notifier).listen(onMessage);
  }

  void onMessage(message) async {
    var body = Body.fromBuffer(message as List<int>);
    var res = ref.read(securityProvider.notifier).decrypt(body.data);
    if (res == null) {
      return;
    }
    switch (body.type) {
      case Type.offer:
        {
          var selfId = ref.watch(configureProvider).deviceId;
          var data = OfferData.fromJson(res);
          var deviceInfo = Device.fromJson(data.deviceInfo);
          var result = await ref
              .read(trustedDeviceManagerProvider.notifier)
              .check(deviceInfo);
          if (!result || deviceInfo.deviceId != body.from) {
            ref.read(wsProvider.notifier).send(Body(
                  type: Type.bye,
                  sessionId: body.sessionId,
                  from: selfId,
                  to: body.from,
                ).writeToBuffer());
          }
          var c = WebRTCItemController();
          if (data.media == 'data') {
            var item = WebRTCItem(
              controller: c,
              selfId: selfId,
              isInvite: false,
              data: data,
              sessionId: body.sessionId,
              deviceInfo: deviceInfo,
            );
            if (state[body.sessionId] != null) {
              state[body.sessionId]!.controller.close!();
            }
            state = {...state, body.sessionId: item};
          } else {
            var item = WebRTCVideoPage(
              controller: c,
              selfId: selfId,
              useScreen: false,
              isInvite: false,
              data: data,
              sessionId: body.sessionId,
              deviceInfo: deviceInfo,
            );

            if (_videoItem != null) {
              _videoItem!.controller.close!();
            }
            _videoItem = item;
            OneContext().push(MaterialPageRoute(builder: (context) {
              return item;
            })).then((value) {
              _videoItem = null;
            });
          }
        }
        break;
      case Type.answer:
        {
          var data = AnswerData.fromJson(res);
          var item = state[body.sessionId];
          if (item != null) {
            item.controller.answerHandler!(data);
          }
          if (_videoItem != null && _videoItem!.sessionId == body.sessionId) {
            _videoItem!.controller.answerHandler!(data);
          }
        }
        break;
      case Type.candidate:
        {
          var data = CandidateData.fromJson(res);
          var item = state[body.sessionId];
          if (item != null) {
            item.controller.candidateHanlder!(data);
          }

          if (_videoItem != null && _videoItem!.sessionId == body.sessionId) {
            _videoItem!.controller.candidateHanlder!(data);
          }
        }
        break;
      case Type.keepalive:
        break;
      case Type.assist:
        {
          var data = AssistData.fromJson(res);
          for (var t in data.publicInfo) {
            var info = uri2PublicInfo(t);
            if (info != null) {
              invite(
                Device(
                  deviceId: info.deviceId,
                  deviceName: "waiting",
                  deviceType: DeviceType.unknown.name,
                  publicKey: info.publicKey,
                ),
              );
            }
          }
        }
      case Type.bye:
        {
          var item = state[body.sessionId];
          if (item != null) {
            item.controller.close!();
          }
          if (_videoItem != null && _videoItem!.sessionId == body.sessionId) {
            _videoItem!.controller.close!();
          }
        }
      default:
        break;
    }
  }

  void remove(String sessionId) {
    state = {...state, sessionId: null};
  }

  void invite(Device deviceInfo) async {
    var result =
        await ref.read(trustedDeviceManagerProvider.notifier).check(deviceInfo);
    if (!result) {
      return;
    }
    var selfId = ref.watch(configureProvider).deviceId;
    var c = WebRTCItemController();
    var sessionId = const Uuid().v4();
    var item = WebRTCItem(
      controller: c,
      selfId: selfId,
      isInvite: true,
      sessionId: sessionId,
      deviceInfo: deviceInfo,
    );

    if (state[sessionId] != null) {
      state[sessionId]!.controller.close!();
    }
    state = {...state, sessionId: item};
  }

  void videoCall(Device deviceInfo, bool useScreen) async {
    var selfId = ref.watch(configureProvider).deviceId;
    var c = WebRTCItemController();
    var sessionId = const Uuid().v4();
    var item = WebRTCVideoPage(
      controller: c,
      selfId: selfId,
      useScreen: useScreen,
      sessionId: sessionId,
      isInvite: true,
      deviceInfo: deviceInfo,
    );
    if (_videoItem != null) {
      _videoItem!.controller.close!();
    }
    _videoItem = item;
    OneContext().push(MaterialPageRoute(builder: (context) {
      return item;
    })).then((value) {
      _videoItem = null;
    });
  }

  void sendPicker() {
    var list = ref.read(pickerListProvider);
    for (var e in state.entries) {
      if (e.value == null) {
        continue;
      }
      for (var picker in list) {
        switch (picker.type) {
          case PickerType.file:
            e.value!.controller.sendFile!(
                picker.data, path.basename(picker.label));
          case PickerType.folder:
            break;
          case PickerType.media:
            e.value!.controller.sendFile!(
                picker.data, path.basename(picker.label));
          case PickerType.text:
            e.value!.controller.sendText!(picker.data, false);
        }
      }
    }
  }

  void sendText(String text, bool fromClipboard) {
    for (var e in state.entries) {
      if (e.value == null) {
        continue;
      }
      e.value!.controller.sendText!(text, fromClipboard);
    }
  }
}
