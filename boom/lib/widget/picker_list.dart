import 'package:boom/provider/picker_provider.dart';
import 'package:boom/widget/dialog/add_data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickerListWidget extends ConsumerWidget {
  const PickerListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pickerList = ref.watch(pickerListProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if (pickerList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("还没有添加数据"),
              )
            else
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: pickerList.length,
                itemBuilder: (context, index) {
                  var picker = pickerList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(picker.type.icon),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            picker.toString(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            ref.read(pickerListProvider.notifier).remove(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            ElevatedButton.icon(
              onPressed: () {
                addDataDialog(ref);
              },
              icon: const Icon(Icons.add),
              label: const Text("添加数据"),
            ),
          ],
        ),
      ),
    );
  }
}
