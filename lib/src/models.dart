import 'package:json_annotation/json_annotation.dart';
import 'package:source_span/source_span.dart';

/// A class that describes a single node in a JSON AST.
class ASTNode {
  /// Creates a new [ASTNode] instance.
  const ASTNode({required this.type, required this.span});

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

  /// The value of this identifier.
  final String value;
}

/// A class that describes a JSON literal.
@JsonSerializable(explicitToJson: true)
class LiteralNode extends ASTNode {
  /// Creates a new [LiteralNode] instance.
  const LiteralNode({required this.value, required super.span})
      : super(type: 'LiteralNode');

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

  /// The key of this property.
  final IdentifierNode key;

  /// The value of this property.
  @JsonKey()
  final ASTNode value;
}
