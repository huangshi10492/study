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

import 'websocket.pbenum.dart';

export 'websocket.pbenum.dart';

class Body extends $pb.GeneratedMessage {
  factory Body({
    Type? type,
    $core.String? from,
    $core.String? to,
    $core.String? sessionId,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (from != null) {
      $result.from = from;
    }
    if (to != null) {
      $result.to = to;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Body._() : super();
  factory Body.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Body.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Body', package: const $pb.PackageName(_omitMessageNames ? '' : 'websocket'), createEmptyInstance: create)
    ..e<Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: Type.offer, valueOf: Type.valueOf, enumValues: Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aOS(3, _omitFieldNames ? '' : 'to')
    ..aOS(4, _omitFieldNames ? '' : 'sessionId', protoName: 'sessionId')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Body clone() => Body()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Body copyWith(void Function(Body) updates) => super.copyWith((message) => updates(message as Body)) as Body;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Body create() => Body._();
  Body createEmptyInstance() => create();
  static $pb.PbList<Body> createRepeated() => $pb.PbList<Body>();
  @$core.pragma('dart2js:noInline')
  static Body getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Body>(create);
  static Body? _defaultInstance;

  @$pb.TagNumber(1)
  Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get to => $_getSZ(2);
  @$pb.TagNumber(3)
  set to($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get data => $_getN(4);
  @$pb.TagNumber(5)
  set data($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => clearField(5);
}

class AnswerData extends $pb.GeneratedMessage {
  factory AnswerData({
    $core.String? sdp,
    $core.String? deviceInfo,
  }) {
    final $result = create();
    if (sdp != null) {
      $result.sdp = sdp;
    }
    if (deviceInfo != null) {
      $result.deviceInfo = deviceInfo;
    }
    return $result;
  }
  AnswerData._() : super();
  factory AnswerData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnswerData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnswerData', package: const $pb.PackageName(_omitMessageNames ? '' : 'websocket'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'deviceInfo', protoName: 'deviceInfo')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnswerData clone() => AnswerData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnswerData copyWith(void Function(AnswerData) updates) => super.copyWith((message) => updates(message as AnswerData)) as AnswerData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnswerData create() => AnswerData._();
  AnswerData createEmptyInstance() => create();
  static $pb.PbList<AnswerData> createRepeated() => $pb.PbList<AnswerData>();
  @$core.pragma('dart2js:noInline')
  static AnswerData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnswerData>(create);
  static AnswerData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceInfo => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceInfo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceInfo() => clearField(2);
}

class OfferData extends $pb.GeneratedMessage {
  factory OfferData({
    $core.String? sdp,
    $core.String? deviceInfo,
    $core.String? media,
  }) {
    final $result = create();
    if (sdp != null) {
      $result.sdp = sdp;
    }
    if (deviceInfo != null) {
      $result.deviceInfo = deviceInfo;
    }
    if (media != null) {
      $result.media = media;
    }
    return $result;
  }
  OfferData._() : super();
  factory OfferData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OfferData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OfferData', package: const $pb.PackageName(_omitMessageNames ? '' : 'websocket'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'deviceInfo', protoName: 'deviceInfo')
    ..aOS(3, _omitFieldNames ? '' : 'media')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OfferData clone() => OfferData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OfferData copyWith(void Function(OfferData) updates) => super.copyWith((message) => updates(message as OfferData)) as OfferData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfferData create() => OfferData._();
  OfferData createEmptyInstance() => create();
  static $pb.PbList<OfferData> createRepeated() => $pb.PbList<OfferData>();
  @$core.pragma('dart2js:noInline')
  static OfferData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OfferData>(create);
  static OfferData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceInfo => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceInfo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceInfo() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get media => $_getSZ(2);
  @$pb.TagNumber(3)
  set media($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMedia() => $_has(2);
  @$pb.TagNumber(3)
  void clearMedia() => clearField(3);
}

class CandidateData extends $pb.GeneratedMessage {
  factory CandidateData({
    $core.String? candidate,
    $core.String? sdpMid,
    $core.int? sdpMLineIndex,
  }) {
    final $result = create();
    if (candidate != null) {
      $result.candidate = candidate;
    }
    if (sdpMid != null) {
      $result.sdpMid = sdpMid;
    }
    if (sdpMLineIndex != null) {
      $result.sdpMLineIndex = sdpMLineIndex;
    }
    return $result;
  }
  CandidateData._() : super();
  factory CandidateData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CandidateData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CandidateData', package: const $pb.PackageName(_omitMessageNames ? '' : 'websocket'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidate')
    ..aOS(2, _omitFieldNames ? '' : 'sdpMid', protoName: 'sdpMid')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'sdpMLineIndex', $pb.PbFieldType.O3, protoName: 'sdpMLineIndex')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CandidateData clone() => CandidateData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CandidateData copyWith(void Function(CandidateData) updates) => super.copyWith((message) => updates(message as CandidateData)) as CandidateData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CandidateData create() => CandidateData._();
  CandidateData createEmptyInstance() => create();
  static $pb.PbList<CandidateData> createRepeated() => $pb.PbList<CandidateData>();
  @$core.pragma('dart2js:noInline')
  static CandidateData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CandidateData>(create);
  static CandidateData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidate => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCandidate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdpMid => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdpMid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSdpMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdpMid() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get sdpMLineIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sdpMLineIndex($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSdpMLineIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSdpMLineIndex() => clearField(3);
}

class AssistData extends $pb.GeneratedMessage {
  factory AssistData({
    $core.Iterable<$core.String>? publicInfo,
  }) {
    final $result = create();
    if (publicInfo != null) {
      $result.publicInfo.addAll(publicInfo);
    }
    return $result;
  }
  AssistData._() : super();
  factory AssistData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssistData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssistData', package: const $pb.PackageName(_omitMessageNames ? '' : 'websocket'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'publicInfo', protoName: 'publicInfo')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssistData clone() => AssistData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssistData copyWith(void Function(AssistData) updates) => super.copyWith((message) => updates(message as AssistData)) as AssistData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssistData create() => AssistData._();
  AssistData createEmptyInstance() => create();
  static $pb.PbList<AssistData> createRepeated() => $pb.PbList<AssistData>();
  @$core.pragma('dart2js:noInline')
  static AssistData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssistData>(create);
  static AssistData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get publicInfo => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
