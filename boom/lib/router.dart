import 'package:boom/pages/assist.dart';
import 'package:boom/pages/nfc.dart';
import 'package:boom/pages/qr_scan.dart';
import 'package:boom/pages/root.dart';
import 'package:boom/pages/trusted_device.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';

const String rootPath = '/';
const String publicQrcodeScanPath = '/public_qrcode_scan';
const String assistPath = '/assist';
const String trustedDeviceListPath = '/settings/trusted_device_list';
const String nfcWritePath = '/settings/nfc_write';
const String videoPath = '/video';

// GoRouter configuration
final router = GoRouter(
  initialLocation: rootPath,
  navigatorKey: OneContext().key,
  routes: [
    GoRoute(
      path: rootPath,
      builder: (context, state) => const RootPage(),
    ),
    GoRoute(
      path: trustedDeviceListPath,
      builder: (context, state) => const TrustDevicePage(),
    ),
    GoRoute(
      path: publicQrcodeScanPath,
      builder: (context, state) => const QRScanPage(),
    ),
    GoRoute(
      path: nfcWritePath,
      builder: (context, state) => const NFCPage(),
    ),
    GoRoute(
      path: assistPath,
      builder: (context, state) => const AssistPage(),
    ),
  ],
);
