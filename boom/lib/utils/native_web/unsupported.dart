import 'package:boom/proto/transport.pb.dart';
import 'package:drift/drift.dart';

Never _unsupported() {
  throw UnsupportedError(
      'No suitable database implementation was found on this platform.');
}

// Depending on the platform the app is compiled to, the following stubs will
// be replaced with the methods in native.dart or web.dart

Future<String> readClipboard() {
  _unsupported();
}

DatabaseConnection connect() {
  _unsupported();
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  _unsupported();
}

void convertToBytes(data, Function(List<int>) callback) {
  _unsupported();
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

  FileTransferState(
      this.filename, this.size, this.isSender, this.savePath, this.md5);

  Future<void> writeData(List<int> data) async {
    _unsupported();
  }

  void complete() {
    _unsupported();
  }

  bool check() {
    _unsupported();
  }
}

class FileMessage {
  FileData data;
  List<int> chunk;
  int lengthInBytes;
  String md5;

  FileMessage(this.chunk, this.data, this.lengthInBytes, this.md5);

  static FileMessage parse(List<int> bytes) {
    _unsupported();
  }
}
