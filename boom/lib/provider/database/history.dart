import 'package:drift/drift.dart';

@DataClassName('History')
class Histories extends Table {
  IntColumn get id => integer().autoIncrement()();
  //内容类型(文本/文件)
  TextColumn get type => text().withLength(min: 0, max: 50)();
  //显示标题
  TextColumn get title => text().withLength(min: 0, max: 255)();
  //内容
  TextColumn get content => text().withLength(min: 0, max: 255)();
  //接收时间
  DateTimeColumn get date => dateTime()();
}
