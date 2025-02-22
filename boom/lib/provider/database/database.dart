import 'package:boom/provider/database/history.dart';
import 'package:boom/provider/database/trusted_device.dart';
import 'package:boom/utils/native_web/native_web.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final database = AppDatabase();
  return database;
}

@DriftDatabase(tables: [TrustedDevices, Histories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 1;

  Stream<List<TrustedDevice>> trustedDeviceList() {
    return select(trustedDevices).watch();
  }

  Future<List<TrustedDevice>> getTrustedDeviceList() {
    return select(trustedDevices).get();
  }

  Future<int> addTrustedDevice(TrustedDevicesCompanion device) {
    return into(trustedDevices).insert(device);
  }

  Future deleteTrustedDeviceById(int id) {
    return (delete(trustedDevices)..where((t) => t.id.equals(id))).go();
  }

  Future<TrustedDevice> searchByDeviceId(String deviceId) {
    return (select(trustedDevices)..where((t) => t.deviceId.equals(deviceId)))
        .getSingle();
  }

  Future<int> updateTrustedDevice(TrustedDevicesCompanion device) {
    return (update(trustedDevices)..where((t) => t.id.equals(device.id.value)))
        .write(device);
  }

  Stream<List<History>> historyList() {
    return select(histories).watch();
  }

  Future<List<History>> getHistoryList() {
    return select(histories).get();
  }

  Future<int> addHistory(HistoriesCompanion history) {
    return into(histories).insert(history);
  }

  Future deleteHistoryById(int id) {
    return (delete(histories)..where((t) => t.id.equals(id))).go();
  }

  Future cleanHistory() {
    return (delete(histories)).go();
  }
}
