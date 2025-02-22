//
//  Generated code. Do not modify.
//  source: lib/proto/websocket.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use typeDescriptor instead')
const Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'offer', '2': 0},
    {'1': 'answer', '2': 1},
    {'1': 'candidate', '2': 2},
    {'1': 'keepalive', '2': 3},
    {'1': 'assist', '2': 4},
    {'1': 'bye', '2': 5},
  ],
};

/// Descriptor for `Type`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List typeDescriptor = $convert.base64Decode(
    'CgRUeXBlEgkKBW9mZmVyEAASCgoGYW5zd2VyEAESDQoJY2FuZGlkYXRlEAISDQoJa2VlcGFsaX'
    'ZlEAMSCgoGYXNzaXN0EAQSBwoDYnllEAU=');

@$core.Deprecated('Use bodyDescriptor instead')
const Body$json = {
  '1': 'Body',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.websocket.Type', '10': 'type'},
    {'1': 'from', '3': 2, '4': 1, '5': 9, '10': 'from'},
    {'1': 'to', '3': 3, '4': 1, '5': 9, '10': 'to'},
    {'1': 'sessionId', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bodyDescriptor = $convert.base64Decode(
    'CgRCb2R5EiMKBHR5cGUYASABKA4yDy53ZWJzb2NrZXQuVHlwZVIEdHlwZRISCgRmcm9tGAIgAS'
    'gJUgRmcm9tEg4KAnRvGAMgASgJUgJ0bxIcCglzZXNzaW9uSWQYBCABKAlSCXNlc3Npb25JZBIS'
    'CgRkYXRhGAUgASgMUgRkYXRh');

@$core.Deprecated('Use answerDataDescriptor instead')
const AnswerData$json = {
  '1': 'AnswerData',
  '2': [
    {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    {'1': 'deviceInfo', '3': 2, '4': 1, '5': 9, '10': 'deviceInfo'},
  ],
};

/// Descriptor for `AnswerData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerDataDescriptor = $convert.base64Decode(
    'CgpBbnN3ZXJEYXRhEhAKA3NkcBgBIAEoCVIDc2RwEh4KCmRldmljZUluZm8YAiABKAlSCmRldm'
    'ljZUluZm8=');

@$core.Deprecated('Use offerDataDescriptor instead')
const OfferData$json = {
  '1': 'OfferData',
  '2': [
    {'1': 'sdp', '3': 1, '4': 1, '5': 9, '10': 'sdp'},
    {'1': 'deviceInfo', '3': 2, '4': 1, '5': 9, '10': 'deviceInfo'},
    {'1': 'media', '3': 3, '4': 1, '5': 9, '10': 'media'},
  ],
};

/// Descriptor for `OfferData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerDataDescriptor = $convert.base64Decode(
    'CglPZmZlckRhdGESEAoDc2RwGAEgASgJUgNzZHASHgoKZGV2aWNlSW5mbxgCIAEoCVIKZGV2aW'
    'NlSW5mbxIUCgVtZWRpYRgDIAEoCVIFbWVkaWE=');

@$core.Deprecated('Use candidateDataDescriptor instead')
const CandidateData$json = {
  '1': 'CandidateData',
  '2': [
    {'1': 'candidate', '3': 1, '4': 1, '5': 9, '10': 'candidate'},
    {'1': 'sdpMid', '3': 2, '4': 1, '5': 9, '10': 'sdpMid'},
    {'1': 'sdpMLineIndex', '3': 3, '4': 1, '5': 5, '10': 'sdpMLineIndex'},
  ],
};

/// Descriptor for `CandidateData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List candidateDataDescriptor = $convert.base64Decode(
    'Cg1DYW5kaWRhdGVEYXRhEhwKCWNhbmRpZGF0ZRgBIAEoCVIJY2FuZGlkYXRlEhYKBnNkcE1pZB'
    'gCIAEoCVIGc2RwTWlkEiQKDXNkcE1MaW5lSW5kZXgYAyABKAVSDXNkcE1MaW5lSW5kZXg=');

@$core.Deprecated('Use assistDataDescriptor instead')
const AssistData$json = {
  '1': 'AssistData',
  '2': [
    {'1': 'publicInfo', '3': 1, '4': 3, '5': 9, '10': 'publicInfo'},
  ],
};

/// Descriptor for `AssistData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assistDataDescriptor = $convert.base64Decode(
    'CgpBc3Npc3REYXRhEh4KCnB1YmxpY0luZm8YASADKAlSCnB1YmxpY0luZm8=');

