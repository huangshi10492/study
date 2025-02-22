import 'dart:async';

import 'package:boom/proto/info.pb.dart';
import 'package:boom/proto/websocket.pb.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/security_provider.dart';
import 'package:boom/provider/server_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/provider/websocket_provider.dart';
import 'package:boom/widget/screen_select_dialog.dart';
import 'package:boom/widget/webrtc_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:one_context/one_context.dart';

enum VideoSource {
  camera,
  screen,
}

class WebRTCVideoPage extends ConsumerStatefulWidget {
  const WebRTCVideoPage({
    super.key,
    required this.controller,
    required this.selfId,
    required this.useScreen,
    required this.sessionId,
    required this.isInvite,
    required this.deviceInfo,
    this.data,
  });

  final WebRTCItemController controller;
  final String selfId;
  final bool useScreen;
  final String sessionId;
  final Device deviceInfo;
  final bool isInvite;
  final OfferData? data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebRTCVideoState();
}

class _WebRTCVideoState extends ConsumerState<WebRTCVideoPage>
    with TickerProviderStateMixin {
  MediaStream? _localStream;
  final _iceServers = {
    'iceServers': [],
  };
  String get sdpSemantics => 'unified-plan';
  final List<RTCRtpSender> _senders = <RTCRtpSender>[];
  VideoSource _videoSource = VideoSource.camera;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final List<RTCIceCandidate> _candidateList = [];
  void Function(RTCIceCandidate candidate)? sendIceCandidate;
  late RTCPeerConnection pc;
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;
  late Device _connectInfo = widget.deviceInfo;
  bool _isConnected = false;

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };
  @override
  void initState() {
    super.initState();
    widget.controller.answerHandler = _onAnswer;
    widget.controller.offerHandler = _onOffer;
    widget.controller.candidateHanlder = _onCandidate;
    widget.controller.close = _close;
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    if (widget.isInvite) {
      _invitePeer();
    } else {
      _onOffer(widget.data!);
    }
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(_rotationController);
  }

  @override
  Future<void> dispose() async {
    FlutterForegroundTask.stopService();
    super.dispose();
    _rotationController.dispose();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
  }

  _invitePeer() async {
    _iceServers['iceServers'] = [
      {
        'urls': 'turn:${ref.read(configureProvider).turnUrl}',
        'username': widget.selfId,
        'credential': widget.selfId
      }
    ];
    await _createSession(
      peerId: widget.deviceInfo.deviceId,
      screenSharing: widget.useScreen,
    );
    _createOffer();
  }

  Future<void> _closeSession() async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    if (pc.connectionState != null &&
        pc.connectionState ==
            RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
      await pc.close();
    }
    _senders.clear();
    _videoSource = VideoSource.camera;
    pc.dispose();
  }

  Future<MediaStream> createStream(
    bool userScreen,
  ) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': userScreen ? false : true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth':
                    '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
    };
    MediaStream stream;
    if (userScreen) {
      if (WebRTC.platformIsDesktop) {
        final source = await OneContext().showDialog<DesktopCapturerSource>(
          builder: (context) => ScreenSelectDialog(),
        );
        stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
          'video': source == null
              ? true
              : {
                  'deviceId': {'exact': source.id},
                  'mandatory': {'frameRate': 30.0}
                }
        });
      } else {
        if (WebRTC.platformIsAndroid) {
          Future<void> requestPermissionForAndroid() async {
            ///检查前台服务权限授予的状态
            final NotificationPermission notificationPermissionStatus =
                await FlutterForegroundTask.checkNotificationPermission();
            if (notificationPermissionStatus !=
                NotificationPermission.granted) {
              //没有授予先去请求
              await FlutterForegroundTask.requestNotificationPermission();
            }
          }

          requestPermissionForAndroid();
          FlutterForegroundTask.init(
            androidNotificationOptions: AndroidNotificationOptions(
              channelId: 'foreground_service',
              channelName: 'Foreground Service Notification',
            ),
            iosNotificationOptions: const IOSNotificationOptions(),
            foregroundTaskOptions: const ForegroundTaskOptions(),
          );
        }
        FlutterForegroundTask.startService(
            notificationTitle: "boom", notificationText: "正在进行屏幕共享");
        try {
          stream = await navigator.mediaDevices
              .getDisplayMedia(<String, dynamic>{'video': true});
        } catch (e) {
          stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
        }
      }
    } else {
      stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }
    setState(() {
      _localRenderer.srcObject = stream;
      if (_localRenderer.srcObject!.getAudioTracks().isNotEmpty) {
        _localRenderer.srcObject!.getAudioTracks()[0].enabled = false;
      }
    });
    return stream;
  }

  Future<void> _createSession({
    required String peerId,
    required bool screenSharing,
  }) async {
    if (widget.isInvite) {
      _localStream = await createStream(screenSharing);
    }
    pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);

    switch (sdpSemantics) {
      case 'plan-b':
        pc.onAddStream = (MediaStream stream) {
          _localRenderer.srcObject = stream;
          setState(() {});
        };
        await pc.addStream(_localStream!);
        break;
      case 'unified-plan':
        // Unified-Plan
        pc.onTrack = (event) {
          if (event.track.kind == 'video' && !widget.isInvite) {
            _remoteRenderer.srcObject = event.streams[0];
            setState(() {});
          }
        };
        if (widget.isInvite) {
          _localStream!.getTracks().forEach((track) async {
            _senders.add(await pc.addTrack(track, _localStream!));
          });
        }
        break;
    }
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
        Navigator.of(context).pop();
      }
    };

    if (widget.isInvite) {
      pc.onRemoveStream = (stream) {
        _remoteRenderer.srcObject = stream;
        setState(() {});
      };
    }

    setState(() {});
  }

  // RTCSessionDescription _fixSdp(RTCSessionDescription s) {
  //   var sdp = s.sdp;
  //   s.sdp =
  //       sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
  //   return s;
  // }

  Future<void> _createOffer() async {
    try {
      RTCSessionDescription s = await pc.createOffer({});
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
          media: 'video',
        ).writeToJson(),
      );
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _createAnswer() async {
    try {
      RTCSessionDescription s = await pc.createAnswer({});
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

  void switchCamera() {
    if (_localStream != null) {
      if (_videoSource != VideoSource.camera) {
        for (var sender in _senders) {
          if (sender.track!.kind == 'video') {
            sender.replaceTrack(_localStream!.getVideoTracks()[0]);
          }
        }
        _videoSource = VideoSource.camera;
        _localRenderer.srcObject = _localStream;
        setState(() {});
      } else {
        Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      }
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
    setState(() {
      _connectInfo = Device.fromJson(data.deviceInfo);
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
    await _createSession(
        peerId: widget.deviceInfo.deviceId, screenSharing: false);
    await pc.setRemoteDescription(RTCSessionDescription(data.sdp, 'offer'));

    _createAnswer();
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
    _closeSession();
    Navigator.pop(context);
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('提示'),
            content: const Text('是否要退出共享？'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  _close();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_connectInfo.deviceName),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.black45),
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: RTCVideoView(
                      widget.isInvite ? _localRenderer : _remoteRenderer),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  if (widget.isInvite && !widget.useScreen)
                    IconButton(
                      onPressed: () {
                        switchCamera();
                      },
                      icon: const Icon(Icons.cameraswitch),
                      tooltip: '切换摄像头',
                    ),
                  IconButton(
                    onPressed: () {
                      _close();
                    },
                    icon: const Icon(Icons.link_off),
                    tooltip: '断开连接',
                  ),
                  IconButton(
                    onPressed: () {
                      if (_rotationController.value == 0.75) {
                        _rotationController.animateTo(0);
                      } else {
                        _rotationController
                            .animateTo(_rotationController.value + 0.25);
                      }
                    },
                    icon: const Icon(Icons.screen_rotation),
                    tooltip: '旋转',
                  ),
                  const Spacer(),
                  const Text('连接状态: '),
                  _isConnected
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          semanticLabel: '已连接',
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          semanticLabel: '未连接',
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
