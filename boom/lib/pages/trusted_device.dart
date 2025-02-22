import 'package:boom/provider/trusted_device_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrustDevicePage extends ConsumerWidget {
  const TrustDevicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trustedDeviceManager = ref.watch(trustedDeviceManagerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '信任设备列表',
        ),
      ),
      body: trustedDeviceManager.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(DeviceType.fromString(data[index].deviceType).icon,
                            size: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(data[index].deviceName),
                              ),
                              const SizedBox(height: 10),
                              Text(data[index].deviceId),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () => _delDialog(
                      context, data[index].deviceId, data[index].id, ref),
                ),
              );
            },
          );
        },
        error: (_, __) {
          return Container();
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

void _delDialog(BuildContext context, String deviceId, int id, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('删除受信任的设备'),
        content: const Text('您确定要删除此受信任的设备吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(trustedDeviceManagerProvider.notifier)
                  .deleteTrustedDevice(id, deviceId);
            },
            child: const Text('确认'),
          ),
        ],
      );
    },
  );
}
