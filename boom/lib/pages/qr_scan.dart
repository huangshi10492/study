import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:boom/utils/uri.dart';
import 'package:boom/widget/dialog/nano_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('二维码扫描'),
      ),
      body: AiBarcodeScanner(
        bottomBarText: '',
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        canPop: false,
        onScan: (String value) {
          var qrCode = uri2PublicInfo(value);
          if (qrCode != null) {
            context.pop(qrCode);
          } else {
            nanoDialog("错误", "二维码无效");
            context.pop(null);
          }
        },
      ),
    );
  }
}
