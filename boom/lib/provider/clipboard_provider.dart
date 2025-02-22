import 'package:boom/provider/configure_provider.dart';
import 'package:boom/provider/signaling_provider.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:boom/utils/native_web/native_web.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clipboardLastTextProvider = StateProvider<String>((ref) => "");

class ClipboardWidget extends ConsumerStatefulWidget {
  final Widget child;
  const ClipboardWidget({super.key, required this.child});

  @override
  ConsumerState<ClipboardWidget> createState() => _ClipboardWidgetState();
}

class _ClipboardWidgetState extends ConsumerState<ClipboardWidget>
    with ClipboardListener {
  @override
  void initState() {
    super.initState();
    if (ref.read(configureProvider).clipboardListen) {
      clipboardWatcher.addListener(this);
      clipboardWatcher.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  Future<void> onClipboardChanged() async {
    var text = await readClipboard();
    if (text != ref.read(clipboardLastTextProvider) && text != "") {
      ref.read(clipboardLastTextProvider.notifier).state = text;
      ref.read(signalingProvider.notifier).sendText(text, true);
    }
  }
}
