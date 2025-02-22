//
//  Generated code. Do not modify.
//  source: lib/proto/info.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use publicDescriptor instead')
const Public$json = {
  '1': 'Public',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'publicKey', '3': 2, '4': 1, '5': 9, '10': 'publicKey'},
  ],
};

/// Descriptor for `Public`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicDescriptor = $convert.base64Decode(
    'CgZQdWJsaWMSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlkEhwKCXB1YmxpY0tleRgCIAEoCV'
    'IJcHVibGljS2V5');

@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'publicKey', '3': 2, '4': 1, '5': 9, '10': 'publicKey'},
    {'1': 'deviceType', '3': 3, '4': 1, '5': 9, '10': 'deviceType'},
    {'1': 'deviceName', '3': 4, '4': 1, '5': 9, '10': 'deviceName'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlkEhwKCXB1YmxpY0tleRgCIAEoCV'
    'IJcHVibGljS2V5Eh4KCmRldmljZVR5cGUYAyABKAlSCmRldmljZVR5cGUSHgoKZGV2aWNlTmFt'
    'ZRgEIAEoCVIKZGV2aWNlTmFtZQ==');

