// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceLocation _$SourceLocationFromJson(Map<String, dynamic> json) =>
    SourceLocation(
      line: (json['line'] as num).toInt(),
      column: (json['column'] as num).toInt(),
    );

Map<String, dynamic> _$SourceLocationToJson(SourceLocation instance) =>
    <String, dynamic>{
      'line': instance.line,
      'column': instance.column,
    };

SourceSpan _$SourceSpanFromJson(Map<String, dynamic> json) => SourceSpan(
      start: SourceLocation.fromJson(json['start'] as Map<String, dynamic>),
      end: SourceLocation.fromJson(json['end'] as Map<String, dynamic>),
      text: json['text'] as String,
    );

Map<String, dynamic> _$SourceSpanToJson(SourceSpan instance) =>
    <String, dynamic>{
      'start': instance.start.toJson(),
      'end': instance.end.toJson(),
      'text': instance.text,
    };

ASTNode _$ASTNodeFromJson(Map<String, dynamic> json) => ASTNode(
      type: json['type'] as String,
      span: SourceSpan.fromJson(json['span'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ASTNodeToJson(ASTNode instance) => <String, dynamic>{
      'type': instance.type,
      'span': instance.span.toJson(),
    };

ObjectNode _$ObjectNodeFromJson(Map<String, dynamic> json) => ObjectNode(
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => ASTNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      span: SourceSpan.fromJson(json['span'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ObjectNodeToJson(ObjectNode instance) =>
    <String, dynamic>{
      'span': instance.span.toJson(),
      'nodes': instance.nodes.map((e) => e.toJson()).toList(),
    };

IdentifierNode _$IdentifierNodeFromJson(Map<String, dynamic> json) =>
    IdentifierNode(
      value: json['value'] as String,
      span: SourceSpan.fromJson(json['span'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IdentifierNodeToJson(IdentifierNode instance) =>
    <String, dynamic>{
      'span': instance.span.toJson(),
      'value': instance.value,
    };

LiteralNode _$LiteralNodeFromJson(Map<String, dynamic> json) => LiteralNode(
      value: json['value'],
      span: SourceSpan.fromJson(json['span'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LiteralNodeToJson(LiteralNode instance) =>
    <String, dynamic>{
      'span': instance.span.toJson(),
      'value': instance.value,
    };

PropertyNode _$PropertyNodeFromJson(Map<String, dynamic> json) => PropertyNode(
      key: IdentifierNode.fromJson(json['key'] as Map<String, dynamic>),
      value: ASTNode.fromJson(json['value'] as Map<String, dynamic>),
      span: SourceSpan.fromJson(json['span'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertyNodeToJson(PropertyNode instance) =>
    <String, dynamic>{
      'span': instance.span.toJson(),
      'key': instance.key.toJson(),
      'value': instance.value.toJson(),
    };
