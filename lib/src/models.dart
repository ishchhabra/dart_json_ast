import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// A class that describes a single location within a source file.
@JsonSerializable(explicitToJson: true)
class SourceLocation {
  /// Creates a new [SourceLocation] instance.
  const SourceLocation({required this.line, required this.column});

  /// Creates a new [SourceLocation] instance from a JSON object.
  factory SourceLocation.fromJson(Map<String, dynamic> json) =>
      _$SourceLocationFromJson(json);

  /// Converts this instance to a JSON object.
  Map<String, dynamic> toJson() => _$SourceLocationToJson(this);

  /// The line of this location in the source.
  final int line;

  /// The column of this location in the source.
  final int column;
}

/// A class that describes a range of characters within a source file.
@JsonSerializable(explicitToJson: true)
class SourceSpan {
  /// Creates a new [SourceSpan] instance.
  const SourceSpan({
    required this.start,
    required this.end,
    required this.text,
  });

  /// Creates a new [SourceSpan] instance from a JSON object.
  factory SourceSpan.fromJson(Map<String, dynamic> json) =>
      _$SourceSpanFromJson(json);

  /// Converts this instance to a JSON object.
  Map<String, dynamic> toJson() => _$SourceSpanToJson(this);

  /// The start location of this span.
  @JsonKey()
  final SourceLocation start;

  /// The end location of this span.
  @JsonKey()
  final SourceLocation end;

  /// The source text of this span.
  final String text;
}

/// A class that describes a single node in a JSON AST.
@JsonSerializable(explicitToJson: true)
class ASTNode {
  /// Creates a new [ASTNode] instance.
  const ASTNode({required this.type, required this.span});

  /// Creates a new [ASTNode] instance from a JSON object.
  factory ASTNode.fromJson(Map<String, dynamic> json) =>
      _$ASTNodeFromJson(json);

  /// Converts this instance to a JSON object.
  Map<String, dynamic> toJson() => _$ASTNodeToJson(this);

  /// The type of this node.
  final String type;

  /// The span of this node in the source.
  final SourceSpan span;
}

/// A class that describes a JSON object.
@JsonSerializable(explicitToJson: true)
class ObjectNode extends ASTNode {
  /// Creates a new [ObjectNode] instance.
  const ObjectNode({
    required this.nodes,
    required super.span,
  }) : super(type: 'ObjectNode');

  /// Creates a new [ObjectNode] instance from a JSON object.
  factory ObjectNode.fromJson(Map<String, dynamic> json) =>
      _$ObjectNodeFromJson(json);

  /// Converts this instance to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$ObjectNodeToJson(this);

  /// The child nodes of this object.
  @JsonKey()
  final List<ASTNode> nodes;
}

/// A class that describes a JSON identifier.
@JsonSerializable(explicitToJson: true)
class IdentifierNode extends ASTNode {
  /// Creates a new [IdentifierNode] instance.
  const IdentifierNode({required this.value, required super.span})
      : super(type: 'IdentifierNode');

  /// Creates a new [IdentifierNode] instance from a JSON object.
  factory IdentifierNode.fromJson(Map<String, dynamic> json) =>
      _$IdentifierNodeFromJson(json);

  /// Converts this instance to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$IdentifierNodeToJson(this);

  /// The value of this identifier.
  final String value;
}

/// A class that describes a JSON literal.
@JsonSerializable(explicitToJson: true)
class LiteralNode extends ASTNode {
  /// Creates a new [LiteralNode] instance.
  const LiteralNode({required this.value, required super.span})
      : super(type: 'LiteralNode');

  /// Creates a new [LiteralNode] instance from a JSON object.
  factory LiteralNode.fromJson(Map<String, dynamic> json) =>
      _$LiteralNodeFromJson(json);

  /// Converts this instance to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LiteralNodeToJson(this);

  /// The value of this literal.
  @JsonKey()
  final dynamic value;
}

/// A class that describes a JSON array.
@JsonSerializable(explicitToJson: true)
class PropertyNode extends ASTNode {
  /// Creates a new [PropertyNode] instance.
  const PropertyNode({
    required this.key,
    required this.value,
    required super.span,
  }) : super(type: 'PropertyNode');

  /// Creates a new [PropertyNode] instance from a JSON object.
  factory PropertyNode.fromJson(Map<String, dynamic> json) =>
      _$PropertyNodeFromJson(json);

  /// Converts this instance to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$PropertyNodeToJson(this);

  /// The key of this property.
  final IdentifierNode key;

  /// The value of this property.
  @JsonKey()
  final ASTNode value;
}
