import 'dart:convert';
import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:boom/proto/info.pb.dart';
import 'package:boom/provider/database/database.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/widget/dialog/bool_dialog.dart';
import 'package:boom/widget/dialog/three_options_dialog.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'trusted_device_manager_provider.g.dart';

@Riverpod(keepAlive: true)
class TrustedDeviceManager extends _$TrustedDeviceManager {
  final List<TrustedDevice> _temporaryDeviceList = [];
  @override
  Future<List<TrustedDevice>> build() async {
    return [
      ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
      ..._temporaryDeviceList
    ];
  }

  Future<int> add(DeviceInfo d) async {
    var trustedDevice = TrustedDevicesCompanion(
      deviceId: Value(d.id),
      deviceName: Value(d.name),
      deviceType: Value(d.type.name),
      publicKey: Value(d.publicKey),
    );
    var t = await ref.read(appDatabaseProvider).addTrustedDevice(trustedDevice);
    state = AsyncValue.data([
      ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
      ..._temporaryDeviceList
    ]);
    return t;
  }

  Future<void> addTemporaryDevice(DeviceInfo d) async {
    var trustedDevice = TrustedDevice(
      id: 0,
      deviceId: d.id,
      deviceName: d.name,
      deviceType: d.type.name,
      publicKey: d.publicKey,
    );
    _temporaryDeviceList.add(trustedDevice);
    state = AsyncValue.data([
      ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
      ..._temporaryDeviceList
    ]);
  }

  Future<DeviceInfo?> searchByDeviceId(String deviceId) async {
    var list = await ref.read(trustedDeviceManagerProvider.future);
    for (var i = 0; i < list.length; i++) {
      if (list[i].deviceId == deviceId) {
        return DeviceInfo.fromDatabase(list[i]);
      }
    }
    return null;
  }

  Future<void> updatePublicKey(
      int id, String deviceId, String publicKey) async {
    if (id == 0) {
      for (var i = 0; i < _temporaryDeviceList.length; i++) {
        if (_temporaryDeviceList[i].deviceId == deviceId) {
          _temporaryDeviceList[i] = TrustedDevice(
            id: 0,
            deviceId: deviceId,
            deviceName: _temporaryDeviceList[i].deviceName,
            deviceType: _temporaryDeviceList[i].deviceType,
            publicKey: publicKey,
          );
        }
      }
    } else {
      await ref.read(appDatabaseProvider).updateTrustedDevice(
            TrustedDevicesCompanion(
              id: Value(id),
              publicKey: Value(publicKey),
            ),
          );
      state = AsyncValue.data([
        ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
        ..._temporaryDeviceList
      ]);
    }
  }

  Future<void> updateInfo(
      int id, String deviceId, String deviceName, String deviceType) async {
    if (id == 0) {
      for (var i = 0; i < _temporaryDeviceList.length; i++) {
        if (_temporaryDeviceList[i].deviceId == deviceId) {
          _temporaryDeviceList[i] = TrustedDevice(
            id: 0,
            deviceId: deviceId,
            deviceName: deviceName,
            deviceType: deviceType,
            publicKey: _temporaryDeviceList[i].publicKey,
          );
        }
      }
    } else {
      await ref.read(appDatabaseProvider).updateTrustedDevice(
            TrustedDevicesCompanion(
              id: Value(id),
              deviceName: Value(deviceName),
              deviceType: Value(deviceType),
            ),
          );
      state = AsyncValue.data([
        ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
        ..._temporaryDeviceList
      ]);
    }
  }

  Future<void> deleteTrustedDevice(int id, String deviceId) async {
    if (id == 0) {
      for (var i = 0; i < _temporaryDeviceList.length; i++) {
        if (_temporaryDeviceList[i].deviceId == deviceId) {
          _temporaryDeviceList.removeAt(i);
        }
      }
    } else {
      ref.read(appDatabaseProvider).deleteTrustedDeviceById(id);
    }
    state = AsyncValue.data([
      ...(await ref.read(appDatabaseProvider).getTrustedDeviceList()),
      ..._temporaryDeviceList
    ]);
  }

  Future<bool> check(Device deviceInfo) async {
    var device = await searchByDeviceId(deviceInfo.deviceId);
    if (device == null) {
      var accept =
          await threeOptionsDialog("信任设备", "是否信任该设备", "信任", "临时信任", "不信任");
      if (accept == null) {
        return false;
      } else if (accept) {
        add(
          DeviceInfo(
            index: 0,
            id: deviceInfo.deviceId,
            name: deviceInfo.deviceName,
            type: DeviceType.fromString(deviceInfo.deviceType),
            publicKey: deviceInfo.publicKey,
          ),
        );
      } else {
        addTemporaryDevice(
          DeviceInfo(
            index: 0,
            id: deviceInfo.deviceId,
            name: deviceInfo.deviceName,
            type: DeviceType.fromString(deviceInfo.deviceType),
            publicKey: deviceInfo.publicKey,
          ),
        );
      }
    } else if (device.publicKey != deviceInfo.publicKey) {
      var accept = await boolDialog("信任设备", "该设备已更改公钥，是否信任该设备", "信任", "不信任");
      if (accept == null || !accept) {
        return false;
      } else {
        updatePublicKey(device.index, device.id, deviceInfo.publicKey);
      }
    }
    return true;
  }
}

enum DeviceType {
  android(name: "android", icon: Icons.phone_android),
  ios(name: "ios", icon: Icons.phone_iphone),
  windows(name: "windows", icon: Icons.desktop_windows_outlined),
  macos(name: "macos", icon: Icons.desktop_mac_outlined),
  linux(name: "linux", icon: Icons.desktop_windows_outlined),
  web(name: "web", icon: Icons.web),
  unknown(name: "unkown", icon: Icons.devices);

  const DeviceType({required this.name, required this.icon});
  final String name;
  final IconData icon;

  static DeviceType fromString(String name) {
    return DeviceType.values
            .firstWhereOrNull((element) => element.name == name) ??
        DeviceType.unknown;
  }
}

class DeviceInfo {
  final int index;
  final String id;
  final String name;
  final DeviceType type;
  final String publicKey;

  const DeviceInfo({
    required this.index,
    required this.id,
    required this.name,
    required this.type,
    required this.publicKey,
  });

  static DeviceInfo fromDatabase(TrustedDevice device) {
    return DeviceInfo(
      index: device.id,
      id: device.deviceId,
      name: device.deviceName,
      type: DeviceType.fromString(device.deviceType),
      publicKey: device.publicKey,
    );
  }

  static Future<String> getDeviceId() async {
    var deviceId = "";
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceId = await androidIdPlugin.getId() ?? const Uuid().v4();
      } else if (isIOS) {
        // var info = await deviceInfoPlugin.iosInfo;
      } else if (isWindows) {
        RegExp regExp = RegExp(r'{(.*?)}');
        deviceId = regExp
                .firstMatch((await deviceInfoPlugin.windowsInfo).deviceId)!
                .group(1) ??
            const Uuid().v4();
      } else if (isMacOS) {
        deviceId =
            (await deviceInfoPlugin.macOsInfo).systemGUID ?? const Uuid().v4();
      } else if (isLinux) {
        deviceId =
            (await deviceInfoPlugin.linuxInfo).machineId ?? const Uuid().v4();
      } else if (isWeb) {
        deviceId = const Uuid().v4();
      }
    } on Exception {
      log('Failed to get platform version');
    }
    return CryptoUtils.getHash(utf8.encode(deviceId), algorithmName: 'MD5');
  }

  static Future<String> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (isAndroid) {
        return (await deviceInfoPlugin.androidInfo).model;
      } else if (isIOS) {
        return (await deviceInfoPlugin.iosInfo).name;
      } else if (isWindows) {
        return (await deviceInfoPlugin.windowsInfo).computerName;
      } else if (isMacOS) {
        return (await deviceInfoPlugin.macOsInfo).computerName;
      } else if (isLinux) {
        return (await deviceInfoPlugin.linuxInfo).name;
      } else if (isWeb) {
        var info = await deviceInfoPlugin.webBrowserInfo;
        return '${info.browserName.name}-${info.platform}';
      }
    } on Exception {
      log('Failed to get device name');
    }
    return "";
  }

  static Future<DeviceType> getDeviceType() async {
    try {
      if (isAndroid) {
        return DeviceType.android;
      } else if (isIOS) {
        return DeviceType.ios;
      } else if (isWindows) {
        return DeviceType.windows;
      } else if (isMacOS) {
        return DeviceType.macos;
      } else if (isLinux) {
        return DeviceType.linux;
      } else if (isWeb) {
        return DeviceType.web;
      }
    } on Exception {
      log('Failed to get device type');
    }
    return DeviceType.unknown;
  }
}
