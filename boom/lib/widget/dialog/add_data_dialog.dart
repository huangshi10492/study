import 'package:boom/provider/picker_provider.dart';
import 'package:boom/widget/big_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_context/one_context.dart';

Future<void> addDataDialog(WidgetRef ref) async {
  await OneContext().showDialog(
    builder: (context) => AlertDialog(
      title: const Text("添加数据"),
      content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: PickerType.getOptions().map(
                      (type) {
                        return BigButton(
                          icon: type.icon,
                          label: type.label,
                          onTap: () async {
                            Navigator.of(context).pop();
                            ref
                                .read(pickerListProvider.notifier)
                                .add(await type.pick());
                          },
                        );
                      },
                    ).toList(),
                  ),
                )
              ])),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("关闭"),
        )
      ],
    ),
  );
}
