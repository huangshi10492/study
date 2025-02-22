import 'package:basic_utils/basic_utils.dart';
import 'package:boom/provider/persistence_provider.dart';
import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:boom/utils/platform.dart';
import 'package:boom/utils/rsa.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'configure_provider.g.dart';

class Config {
  String publicKey = "";
  String privateKey = "";
  int port = 0;
  String downloadPath = "";
  String websocketUrl = "";
  String turnUrl = "";
  String deviceId = "";
  bool clipboardListen = true;
  bool startServerAlways = false;
  Config({
    required this.publicKey,
    required this.privateKey,
    required this.port,
    required this.downloadPath,
    required this.websocketUrl,
    required this.turnUrl,
    required this.deviceId,
    required this.clipboardListen,
    required this.startServerAlways,
  });
  Config copyWith({
    String? publicKey,
    String? privateKey,
    int? port,
    String? downloadPath,
    String? websocketUrl,
    String? turnUrl,
    bool? clipboardListen,
    bool? startServerAlways,
  }) {
    return Config(
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
      port: port ?? this.port,
      downloadPath: downloadPath ?? this.downloadPath,
      websocketUrl: websocketUrl ?? this.websocketUrl,
      turnUrl: turnUrl ?? this.turnUrl,
      deviceId: deviceId,
      clipboardListen: clipboardListen ?? this.clipboardListen,
      startServerAlways: startServerAlways ?? this.startServerAlways,
    );
  }
}

@Riverpod(keepAlive: true)
class Configure extends _$Configure {
  @override
  Config build() {
    var sp = ref.read(persistenceServiceProvider).prefs;
    var config = Config(
      publicKey: sp.getString("publicKey")!,
      privateKey: sp.getString("privateKey")!,
      port: sp.getInt("port") ?? 8989,
      downloadPath: sp.getString("downloadPath")!,
      websocketUrl: sp.getString("websocketUrl") ?? "8.134.132.159:3000",
      turnUrl: sp.getString("turnUrl") ?? "8.134.132.159:3478",
      deviceId: sp.getString("deviceId")!,
      clipboardListen: sp.getBool("clipboardListen") ?? false,
      startServerAlways: sp.getBool("startServerAwaly") ?? false,
    );
    return config;
  }

  static Future<void> check(SharedPreferences sp) async {
    var publicKey = sp.getString("publicKey") ?? "";
    var privateKey = sp.getString("privateKey") ?? "";
    if (publicKey == "" || privateKey == "") {
      var keyPair = CryptoUtils.generateRSAKeyPair(keySize: 1024);
      sp.setString("publicKey", getPublicKeyString(keyPair));
      sp.setString("privateKey", getPrivateKeyString(keyPair));
    }
    var downloadPath = sp.getString("downloadPath") ?? "";
    if (downloadPath == "") {
      if (isWeb) {
        sp.setString("downloadPath", "");
      } else {
        var t = await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        sp.setString("downloadPath", t.path);
      }
    }
    var deviceId = sp.getString("deviceId") ?? "";
    if (deviceId == "") {
      var t = await DeviceInfo.getDeviceId();
      sp.setString("deviceId", t);
    }
  }

  void updatePublicKey(String key) {
    ref.read(persistenceServiceProvider).prefs.setString("publicKey", key);
    state = state.copyWith(publicKey: key);
  }

  void updatePrivateKey(String key) {
    ref.read(persistenceServiceProvider).prefs.setString("privateKey", key);
    state = state.copyWith(privateKey: key);
  }

  void updatePort(int port) {
    ref.read(persistenceServiceProvider).prefs.setInt("port", port);
    state = state.copyWith(port: port);
  }

  void updateDownloadPath(String path) {
    ref.read(persistenceServiceProvider).prefs.setString("downloadPath", path);
    state = state.copyWith(downloadPath: path);
  }

  void updateWebsocketUrl(String url) {
    ref.read(persistenceServiceProvider).prefs.setString("websocketUrl", url);
    state = state.copyWith(websocketUrl: url);
  }

  void updateTurnUrl(String url) {
    ref.read(persistenceServiceProvider).prefs.setString("turnUrl", url);
    state = state.copyWith(turnUrl: url);
  }

  void changeClipboardListen(bool value) {
    ref
        .read(persistenceServiceProvider)
        .prefs
        .setBool("clipboardListen", value);
    state = state.copyWith(clipboardListen: value);
  }

  void changeStartServerAlways(bool value) {
    ref
        .read(persistenceServiceProvider)
        .prefs
        .setBool("startServerAlways", value);
    state = state.copyWith(startServerAlways: value);
  }
}
