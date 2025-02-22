import 'package:drift/drift.dart';

class TrustedDevices extends Table {
  IntColumn get id => integer().autoIncrement()();
  //设备id
  TextColumn get deviceId => text()();
  //设备名称
  TextColumn get deviceName => text()();
  //设备类型
  TextColumn get deviceType => text()();
  //公钥
  TextColumn get publicKey => text()();
}
