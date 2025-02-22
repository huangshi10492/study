//
//  Generated code. Do not modify.
//  source: lib/proto/transport.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TextMessage extends $pb.GeneratedMessage {
  factory TextMessage({
    $core.String? type,
    $core.String? content,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (content != null) {
      $result.content = content;
    }
    return $result;
  }
  TextMessage._() : super();
  factory TextMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TextMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'transport'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextMessage clone() => TextMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextMessage copyWith(void Function(TextMessage) updates) => super.copyWith((message) => updates(message as TextMessage)) as TextMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextMessage create() => TextMessage._();
  TextMessage createEmptyInstance() => create();
  static $pb.PbList<TextMessage> createRepeated() => $pb.PbList<TextMessage>();
  @$core.pragma('dart2js:noInline')
  static TextMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextMessage>(create);
  static TextMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);
}

class FileData extends $pb.GeneratedMessage {
  factory FileData({
    $core.String? name,
    $core.String? md5,
    $core.int? size,
    $core.int? chunkStart,
    $core.List<$core.int>? chunk,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (md5 != null) {
      $result.md5 = md5;
    }
    if (size != null) {
      $result.size = size;
    }
    if (chunkStart != null) {
      $result.chunkStart = chunkStart;
    }
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  FileData._() : super();
  factory FileData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileData', package: const $pb.PackageName(_omitMessageNames ? '' : 'transport'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'md5')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'chunkStart', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileData clone() => FileData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileData copyWith(void Function(FileData) updates) => super.copyWith((message) => updates(message as FileData)) as FileData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileData create() => FileData._();
  FileData createEmptyInstance() => create();
  static $pb.PbList<FileData> createRepeated() => $pb.PbList<FileData>();
  @$core.pragma('dart2js:noInline')
  static FileData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileData>(create);
  static FileData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get md5 => $_getSZ(1);
  @$pb.TagNumber(2)
  set md5($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMd5() => $_has(1);
  @$pb.TagNumber(2)
  void clearMd5() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get chunkStart => $_getIZ(3);
  @$pb.TagNumber(4)
  set chunkStart($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChunkStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearChunkStart() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get chunk => $_getN(4);
  @$pb.TagNumber(5)
  set chunk($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChunk() => $_has(4);
  @$pb.TagNumber(5)
  void clearChunk() => clearField(5);
}

class FileAck extends $pb.GeneratedMessage {
  factory FileAck({
    $core.String? md5,
    $core.int? nextChunk,
  }) {
    final $result = create();
    if (md5 != null) {
      $result.md5 = md5;
    }
    if (nextChunk != null) {
      $result.nextChunk = nextChunk;
    }
    return $result;
  }
  FileAck._() : super();
  factory FileAck.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileAck.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileAck', package: const $pb.PackageName(_omitMessageNames ? '' : 'transport'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'md5')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'nextChunk', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileAck clone() => FileAck()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileAck copyWith(void Function(FileAck) updates) => super.copyWith((message) => updates(message as FileAck)) as FileAck;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileAck create() => FileAck._();
  FileAck createEmptyInstance() => create();
  static $pb.PbList<FileAck> createRepeated() => $pb.PbList<FileAck>();
  @$core.pragma('dart2js:noInline')
  static FileAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileAck>(create);
  static FileAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get md5 => $_getSZ(0);
  @$pb.TagNumber(1)
  set md5($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMd5() => $_has(0);
  @$pb.TagNumber(1)
  void clearMd5() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get nextChunk => $_getIZ(1);
  @$pb.TagNumber(2)
  set nextChunk($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNextChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextChunk() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
