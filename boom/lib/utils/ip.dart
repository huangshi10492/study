import 'dart:io';

import 'package:collection/collection.dart';
import 'package:network_info_plus/network_info_plus.dart';

Future<List<String>> getIPs() async {
  final info = NetworkInfo();
  String? ip;
  ip = await info.getWifiIP();

  List<String> nativeResult = [];
  // fallback with dart:io NetworkInterface
  final result = (await NetworkInterface.list())
      .map((networkInterface) => networkInterface.addresses)
      .expand((ip) => ip);
  nativeResult = result
      .where((ip) => ip.type == InternetAddressType.IPv4)
      .map((address) => address.address)
      .toList();

  final addresses = _rankIpAddresses(nativeResult, ip);
  return addresses;
}

List<String> _rankIpAddresses(
    List<String> nativeResult, String? thirdPartyResult) {
  if (thirdPartyResult == null) {
    // only take the list
    return nativeResult._rankIpAddresses(null);
  } else if (nativeResult.isEmpty) {
    // only take the first IP from third party library
    return [thirdPartyResult];
  } else if (thirdPartyResult.endsWith('.1')) {
    // merge
    return {thirdPartyResult, ...nativeResult}.toList()._rankIpAddresses(null);
  } else {
    // merge but prefer result from third party library
    return {thirdPartyResult, ...nativeResult}
        .toList()
        ._rankIpAddresses(thirdPartyResult);
  }
}

/// Sorts Ip addresses with first being the most likely primary local address
/// Currently,
/// - sorts ending with ".1" last
/// - primary is always first
extension ListIpExt on List<String> {
  List<String> _rankIpAddresses(String? primary) {
    return sorted((a, b) {
      int scoreA = a == primary ? 10 : (a.endsWith('.1') ? 0 : 1);
      int scoreB = b == primary ? 10 : (b.endsWith('.1') ? 0 : 1);
      return scoreB.compareTo(scoreA);
    });
  }
}
