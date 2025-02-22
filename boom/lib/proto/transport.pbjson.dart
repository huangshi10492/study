//
//  Generated code. Do not modify.
//  source: lib/proto/transport.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use textMessageDescriptor instead')
const TextMessage$json = {
  '1': 'TextMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `TextMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageDescriptor = $convert.base64Decode(
    'CgtUZXh0TWVzc2FnZRISCgR0eXBlGAEgASgJUgR0eXBlEhgKB2NvbnRlbnQYAiABKAlSB2Nvbn'
    'RlbnQ=');

@$core.Deprecated('Use fileDataDescriptor instead')
const FileData$json = {
  '1': 'FileData',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'md5', '3': 2, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'size', '3': 3, '4': 1, '5': 5, '10': 'size'},
    {'1': 'chunk_start', '3': 4, '4': 1, '5': 5, '10': 'chunkStart'},
    {'1': 'chunk', '3': 5, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `FileData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDataDescriptor = $convert.base64Decode(
    'CghGaWxlRGF0YRISCgRuYW1lGAEgASgJUgRuYW1lEhAKA21kNRgCIAEoCVIDbWQ1EhIKBHNpem'
    'UYAyABKAVSBHNpemUSHwoLY2h1bmtfc3RhcnQYBCABKAVSCmNodW5rU3RhcnQSFAoFY2h1bmsY'
    'BSABKAxSBWNodW5r');

@$core.Deprecated('Use fileAckDescriptor instead')
const FileAck$json = {
  '1': 'FileAck',
  '2': [
    {'1': 'md5', '3': 1, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'next_chunk', '3': 2, '4': 1, '5': 5, '10': 'nextChunk'},
  ],
};

/// Descriptor for `FileAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileAckDescriptor = $convert.base64Decode(
    'CgdGaWxlQWNrEhAKA21kNRgBIAEoCVIDbWQ1Eh0KCm5leHRfY2h1bmsYAiABKAVSCW5leHRDaH'
    'Vuaw==');

