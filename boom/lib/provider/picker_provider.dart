import 'package:boom/utils/file.dart';
import 'package:boom/utils/platform.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'picker_provider.g.dart';

enum PickerType {
  file(Icons.file_present_rounded, "文件"),
  folder(Icons.folder, "文件夹"),
  media(Icons.image, "媒体"),
  text(Icons.subject, "文本");

  const PickerType(this.icon, this.label);

  final IconData icon;
  final String label;

  /// Returns the options for the current platform.
  static List<PickerType> getOptions() {
    if (isAndroid) {
      return [
        PickerType.file,
        PickerType.media,
        PickerType.text,
        PickerType.folder,
      ];
    } else if (isWeb) {
      return [
        PickerType.file,
        PickerType.text,
      ];
    } else {
      return [
        PickerType.file,
        PickerType.folder,
        PickerType.text,
      ];
    }
  }

  Future<List<Picker>> pick() async {
    switch (this) {
      case PickerType.file:
        return await Picker.pickerFile();
      case PickerType.folder:
        return await Picker.pickerFolder();
      case PickerType.media:
        return await Picker.pickerMedia();
      case PickerType.text:
        return await Picker.pickerText();
    }
  }
}

class Picker {
  PickerType type;
  dynamic data;
  String label = "";

  Picker(this.type);

  @override
  String toString() {
    switch (type) {
      case PickerType.file:
        return label;
      case PickerType.folder:
        break;
      case PickerType.media:
        return label;
      case PickerType.text:
        return data.toString();
    }
    return "";
  }

  static Future<List<Picker>> pickerText() async {
    var res = await OneContext().showDialog<Picker?>(
      builder: (context) {
        final TextEditingController textController = TextEditingController();
        return AlertDialog(
          title: const Text('发送文本'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLength: 250,
                controller: textController,
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消')),
            TextButton(
              onPressed: () {
                var picker = Picker(PickerType.text)
                  ..data = textController.text;
                Navigator.of(context).pop(picker);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    if (res != null) {
      return [res];
    }
    return [];
  }

  static Future<List<Picker>> pickerMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );
    List<Picker> res = [];
    if (result != null && result.count > 0) {
      var files = result.files;
      for (var file in files) {
        if (isWeb) {
          var picker = Picker(PickerType.media)
            ..data = file.bytes
            ..label = file.name;
          res.add(picker);
        } else {
          var picker = Picker(PickerType.media)
            ..data = await file.xFile.readAsBytes()
            ..label = file.path!;
          res.add(picker);
        }
      }
    }
    return res;
  }

  static Future<List<Picker>> pickerFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    List<Picker> res = [];
    if (result != null && result.count > 0) {
      var files = result.files;
      for (var file in files) {
        if (isWeb) {
          var picker = Picker(PickerType.media)
            ..data = file.bytes
            ..label = file.name;
          res.add(picker);
        } else {
          var picker = Picker(PickerType.media)
            ..data = await file.xFile.readAsBytes()
            ..label = file.path!;
          res.add(picker);
        }
      }
    }
    return res;
  }

  static Future<List<Picker>> pickerFolder() async {
    List<Picker> res = [];
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      var files = recursionFile(directoryPath);
      for (var file in files) {
        var picker = Picker(PickerType.file)
          ..data = await file.readAsBytes()
          ..label = file.path;
        res.add(picker);
      }
    }
    return res;
  }
}

@Riverpod(keepAlive: true)
class PickerList extends _$PickerList {
  @override
  List<Picker> build() {
    return [];
  }

  void add(List<Picker> list) {
    state = [...state, ...list];
  }

  void remove(int index) {
    state.removeAt(index);
    state = [...state];
  }
}
