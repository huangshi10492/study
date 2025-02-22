import 'dart:convert';

import 'package:boom/proto/info.pb.dart';

Public? uri2PublicInfo(String uriString) {
  var uri = Uri.parse(uriString);
  var data = uri.queryParameters["data"];
  if (data == null) {
    return null;
  }
  return Public.fromBuffer(base64.decode(data));
}

String publicInfo2Uri(Public info) {
  var data = info.writeToBuffer();
  var uri = Uri(
    scheme: "boom",
    host: "connect",
    queryParameters: {"data": base64.encode(data)},
  );
  return uri.toString();
}
