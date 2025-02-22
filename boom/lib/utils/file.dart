import 'dart:io';

import 'package:open_filex/open_filex.dart';

Future<void> openFolder(String path) async {
  if (!path.endsWith('/')) {
    path = '$path/';
  }
  await OpenFilex.open(path);
}

List<File> recursionFile(String pathName) {
  var res = <File>[];
  Directory dir = Directory(pathName);
  List<FileSystemEntity> entities = dir.listSync();
  for (var entity in entities) {
    if (entity is File) {
      res.add(entity);
    } else if (entity is Directory) {
      res.addAll(recursionFile(entity.path));
    }
  }
  return res;
}
