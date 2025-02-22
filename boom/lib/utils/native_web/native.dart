import 'dart:io';

import 'package:boom/utils/logger.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:boom/proto/transport.pb.dart';
import 'package:boom/utils/platform.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

Future<String> readClipboard() async {
  var text = "";
  if (isWindows) {
    await Future.delayed(const Duration(milliseconds: 300));
  }
  ClipboardData? newClipboardData =
      await Clipboard.getData(Clipboard.kTextPlain);
  if (newClipboardData == null || newClipboardData.text == null) {
    Logger().talker.error("获取剪切板内容失败");
    return "";
  }
  text = newClipboardData.text ?? "";
  Logger().talker.info("剪切板内容：$text");
  if (text.length > 250) {
    return "";
  }
  return text;
}

Future<File> get databaseFile async {
  // We use `path_provider` to find a suitable path to store our data in.
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = path.join(appDir.path, 'todos.db');
  return File(dbPath);
}

/// Obtains a database connection for running drift in a Dart VM.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

      final cachebase = (await getTemporaryDirectory()).path;

      // We can't access /tmp on Android, which sqlite3 would try by default.
      // Explicitly tell it about the correct temporary directory.
      sqlite3.tempDirectory = cachebase;
    }

    return NativeDatabase.createBackgroundConnection(
      await databaseFile,
    );
  }));
}

void convertToBytes(data, Function(List<int>) callback) {
  callback(data);
}

class FileTransferState {
  Map<int, FileMessage> receiveQueue = {};
  int size = 0;
  int nextChunk = 0;
  int chunkStart = 0;
  bool processing = false;
  bool fileCompleted = false;
  bool isSender = false;
  String md5 = '';
  String filename = "";
  String savePath = "";
  List<int> fileData = [];

  File? file;

  FileTransferState(
      this.filename, this.size, this.isSender, this.savePath, this.md5);

  Future<void> writeData(List<int> data) async {
    if (file == null) {
      await init();
    }
    if (file != null) {
      await file!.writeAsBytes(data, mode: FileMode.append);
    }
  }

  Future<void> init() async {
    var e = path.extension(savePath);
    var o = path.withoutExtension(savePath);
    // 检查文件是否存在
    bool fileExists = await File(savePath).exists();
    if (fileExists) {
      int i = 1;
      while (await File('$o($i)$e').exists()) {
        i++;
      }
      savePath = '$o($i)$e';
    }
    file = File(savePath);
    await file!.create(recursive: true);
  }

  void complete() {}

  bool check() {
    var md5 = crypto.md5.convert(file!.readAsBytesSync()).toString();
    if (md5 == this.md5) {
      return true;
    } else {
      return false;
    }
  }
}

class FileMessage {
  FileData data;
  List<int> chunk;
  int lengthInBytes;
  String md5;

  FileMessage(this.chunk, this.data, this.lengthInBytes, this.md5);

  static FileMessage parse(List<int> bytes) {
    var data = FileData.fromBuffer(bytes);
    var chunk = data.chunk;
    return FileMessage(chunk, data, chunk.length, data.md5);
  }
}
