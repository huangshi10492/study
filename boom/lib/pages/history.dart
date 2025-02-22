import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/database/database.dart';
import 'package:boom/utils/file.dart';
import 'package:boom/widget/dialog/bool_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
        actions: [
          IconButton(
            onPressed: () {
              openFolder(ref.read(configureProvider).downloadPath);
            },
            icon: const Icon(Icons.folder),
          ),
          IconButton(
            onPressed: () async {
              var result = await boolDialog('是否清空', '', '确定', '取消');
              if (result != null && result) {
                ref.read(appDatabaseProvider).cleanHistory();
              }
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: StreamBuilder(
        stream: ref.watch(appDatabaseProvider).historyList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('无数据'));
              }
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final history = snapshot.data![index];
                  switch (history.type) {
                    case 'file':
                      return ListTile(
                        leading: const Icon(Icons.attach_file),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            ref
                                .read(appDatabaseProvider)
                                .deleteHistoryById(history.id);
                          },
                        ),
                        title: Text(history.title),
                        subtitle: Text(history.content),
                        onTap: () {
                          OpenFilex.open(history.content);
                        },
                      );
                    case 'text':
                      return ListTile(
                        leading: const Icon(Icons.text_fields),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            ref
                                .read(appDatabaseProvider)
                                .deleteHistoryById(history.id);
                          },
                        ),
                        title: Text(history.title),
                        subtitle: Text(history.content),
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: history.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('内容已复制到剪贴板'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                  }
                  return null;
                },
              );
            case ConnectionState.none:
              return const Center(child: Text('无数据'));
            case ConnectionState.done:
              return const Text('Stream 已关闭');
          }
        },
      ),
    );
  }
}
