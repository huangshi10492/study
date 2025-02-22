//
//  Generated code. Do not modify.
//  source: lib/proto/websocket.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Type extends $pb.ProtobufEnum {
  static const Type offer = Type._(0, _omitEnumNames ? '' : 'offer');
  static const Type answer = Type._(1, _omitEnumNames ? '' : 'answer');
  static const Type candidate = Type._(2, _omitEnumNames ? '' : 'candidate');
  static const Type keepalive = Type._(3, _omitEnumNames ? '' : 'keepalive');
  static const Type assist = Type._(4, _omitEnumNames ? '' : 'assist');
  static const Type bye = Type._(5, _omitEnumNames ? '' : 'bye');

  static const $core.List<Type> values = <Type> [
    offer,
    answer,
    candidate,
    keepalive,
    assist,
    bye,
  ];

  static final $core.Map<$core.int, Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Type? valueOf($core.int value) => _byValue[value];

  const Type._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
