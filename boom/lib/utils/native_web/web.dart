import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:crypto/crypto.dart' as crypto;
import 'package:boom/proto/transport.pb.dart';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

String readClipboard() {
  return "";
}

/// Obtains a database connection for running drift on the web.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    final db = await WasmDatabase.open(
      databaseName: 'todo-app',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (db.missingFeatures.isNotEmpty) {
      debugPrint('Using ${db.chosenImplementation} due to unsupported '
          'browser features: ${db.missingFeatures}');
    }

    return db.resolvedExecutor;
  }));
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // Unfortunately, validating database schemas only works for native platforms
  // right now.
  // As we also have migration tests (see the `Testing migrations` section in
  // the readme of this example), this is not a huge issue.
}

void convertToBytes(data, Function(List<int>) callback) {
  Blob blob = data as Blob;

  final reader = FileReader();

  reader.readAsArrayBuffer(blob);
  List<int> res = [];

  reader.onLoadEnd.listen((event) {
    res = reader.result as List<int>;
    callback(res);
  });
}

class FileTransferState {
  Map<int, FileMessage> receiveQueue = {};
  int size = 0;
  int nextChunk = 0;
  int chunkStart = 0;
  bool processing = false;
  bool fileCompleted = false;
  bool isSender = false;
  String md5 = "";
  String filename = "";
  String savePath = "";
  List<int> fileData = [];

  List<int> data = List.empty(growable: true);

  FileTransferState(
      this.filename, this.size, this.isSender, this.savePath, this.md5);

  Future<void> writeData(List<int> data) async {
    this.data.addAll(data);
  }

  void complete() {
    // Encode our file in base64
    final base64 = base64Encode(data);
    // Create the link with the file
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';

    anchor.download = filename;

    // trigger download
    document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  bool check() {
    var md5 = crypto.md5.convert(fileData).toString();
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
