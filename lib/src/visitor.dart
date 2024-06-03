import 'package:json_ast/src/models.dart';
import 'package:meta/meta.dart';

/// A class that visits a JSON AST.
class JsonASTVisitor {
  /// Creates a new [JsonASTVisitor] instance.
  const JsonASTVisitor({required this.node});

  /// The node to visit.
  final ASTNode node;

  /// Visits a [LiteralNode].
  @mustCallSuper
  void visitLiteralNode(LiteralNode node) {}

  /// Visits an [IdentifierNode].
  @mustCallSuper
  void visitIdentifierNode(IdentifierNode node) {}

  /// Visits an [ArrayNode].
  @mustCallSuper
  void visitArrayNode(ArrayNode arrayNode) {
    for (final node in arrayNode.nodes) {
      visitAstNode(node);
    }
  }

  /// Visits an [ObjectNode].
  @mustCallSuper
  void visitObjectNode(ObjectNode objectNode) {
    for (final node in objectNode.nodes) {
      visitAstNode(node);
    }
  }

  /// Visits a [PropertyNode].
  @mustCallSuper
  void visitPropertyNode(PropertyNode propertyNode) {
    visitAstNode(propertyNode.key);
    visitAstNode(propertyNode.value);
  }

  /// Visits a [ASTNode].
  void visitAstNode(ASTNode node) {
    switch (node) {
      case ArrayNode():
        visitArrayNode(node);
      case ObjectNode():
        visitObjectNode(node);
      case IdentifierNode():
        visitIdentifierNode(node);
      case LiteralNode():
        visitLiteralNode(node);
      case PropertyNode():
        visitPropertyNode(node);
    }
  }

  /// Visits the JSON AST.
  void visit() {
    visitAstNode(node);
  }
}
