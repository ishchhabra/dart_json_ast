import 'package:json_ast/json_ast.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/scaffolding.dart';

class _MockSingleArgFunction<R, P1> extends Mock {
  _MockSingleArgFunction(this.r) : super();

  R r;

  R call(P1 p1);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    super.noSuchMethod(invocation);
    return r;
  }
}

class TestVisitor extends JsonASTVisitor {
  const TestVisitor({
    required super.node,
    this.onVisitLiteralNode,
    this.onVisitIdentifierNode,
    this.onVisitArrayNode,
    this.onVisitObjectNode,
    this.onVisitPropertyNode,
  });

  final void Function(LiteralNode node)? onVisitLiteralNode;
  final void Function(IdentifierNode node)? onVisitIdentifierNode;
  final void Function(ArrayNode arrayNode)? onVisitArrayNode;
  final void Function(ObjectNode objectNode)? onVisitObjectNode;
  final void Function(PropertyNode propertyNode)? onVisitPropertyNode;

  @override
  void visitLiteralNode(LiteralNode node) {
    super.visitLiteralNode(node);
    onVisitLiteralNode?.call(node);
  }

  @override
  void visitIdentifierNode(IdentifierNode node) {
    super.visitIdentifierNode(node);
    onVisitIdentifierNode?.call(node);
  }

  @override
  void visitArrayNode(ArrayNode arrayNode) {
    super.visitArrayNode(arrayNode);
    onVisitArrayNode?.call(arrayNode);
  }

  @override
  void visitObjectNode(ObjectNode objectNode) {
    super.visitObjectNode(objectNode);
    onVisitObjectNode?.call(objectNode);
  }

  @override
  void visitPropertyNode(PropertyNode propertyNode) {
    super.visitPropertyNode(propertyNode);
    onVisitPropertyNode?.call(propertyNode);
  }
}

class _MockSourceSpan extends Mock implements SourceSpan {}

void main() {
  group('JsonASTVisitor', () {
    late LiteralNode literalNode;
    late IdentifierNode identifierNode;
    late PropertyNode propertyNode;
    late ArrayNode arrayNode;
    late ObjectNode objectNode;

    setUp(() {
      literalNode = LiteralNode(value: 'hello world', span: _MockSourceSpan());
      identifierNode =
          IdentifierNode(value: 'hello world', span: _MockSourceSpan());
      propertyNode = PropertyNode(
        key: identifierNode,
        value: literalNode,
        span: _MockSourceSpan(),
      );
      arrayNode = ArrayNode(
        nodes: [literalNode],
        span: _MockSourceSpan(),
      );
      objectNode = ObjectNode(
        nodes: [propertyNode],
        span: _MockSourceSpan(),
      );
    });

    group('LiteralNode', () {
      test('visitLiteralNode is called when visiting a LiteralNode', () {
        final mockOnVisitLiteralNode =
            _MockSingleArgFunction<void, LiteralNode>(null);
        TestVisitor(
          node: literalNode,
          onVisitLiteralNode: mockOnVisitLiteralNode.call,
        ).visit();

        verify(() => mockOnVisitLiteralNode(literalNode)).called(1);
      });
    });

    group('IdentifierNode', () {
      test('visitIdentifierNode is called when visiting an IdentifierNode', () {
        final mockOnVisitIdentifierNode =
            _MockSingleArgFunction<void, IdentifierNode>(null);
        TestVisitor(
          node: identifierNode,
          onVisitIdentifierNode: mockOnVisitIdentifierNode.call,
        ).visit();

        verify(() => mockOnVisitIdentifierNode(identifierNode)).called(1);
      });
    });

    group('ArrayNode', () {
      test('visitArrayNode is called when visiting an ArrayNode', () {
        final mockOnVisitArrayNode =
            _MockSingleArgFunction<void, ArrayNode>(null);
        TestVisitor(
          node: arrayNode,
          onVisitArrayNode: mockOnVisitArrayNode.call,
        ).visit();

        verify(() => mockOnVisitArrayNode(arrayNode)).called(1);
      });

      test('calls the correct callbacks for each node type in ArrayNode', () {
        final mockOnVisitArrayNode =
            _MockSingleArgFunction<void, ArrayNode>(null);
        final mockOnVisitLiteralNode =
            _MockSingleArgFunction<void, LiteralNode>(null);
        TestVisitor(
          node: arrayNode,
          onVisitArrayNode: mockOnVisitArrayNode.call,
          onVisitLiteralNode: mockOnVisitLiteralNode.call,
        ).visit();

        verify(() => mockOnVisitArrayNode(arrayNode)).called(1);
        verify(() => mockOnVisitLiteralNode(literalNode)).called(1);
      });
    });

    group('ObjectNode', () {
      test('visitObjectNode is called when visiting an ObjectNode', () {
        final mockOnVisitObjectNode =
            _MockSingleArgFunction<void, ObjectNode>(null);
        TestVisitor(
          node: objectNode,
          onVisitObjectNode: mockOnVisitObjectNode.call,
        ).visit();

        verify(() => mockOnVisitObjectNode(objectNode)).called(1);
      });

      test('calls the correct callbacks for each node type in ObjectNode', () {
        final mockOnVisitObjectNode =
            _MockSingleArgFunction<void, ObjectNode>(null);
        final mockOnVisitPropertyNode =
            _MockSingleArgFunction<void, PropertyNode>(null);
        final mockOnVisitIdentifierNode =
            _MockSingleArgFunction<void, IdentifierNode>(null);
        final mockOnVisitLiteralNode =
            _MockSingleArgFunction<void, LiteralNode>(null);
        TestVisitor(
          node: objectNode,
          onVisitObjectNode: mockOnVisitObjectNode.call,
          onVisitPropertyNode: mockOnVisitPropertyNode.call,
          onVisitIdentifierNode: mockOnVisitIdentifierNode.call,
          onVisitLiteralNode: mockOnVisitLiteralNode.call,
        ).visit();

        verify(() => mockOnVisitObjectNode(objectNode)).called(1);
        verify(() => mockOnVisitPropertyNode(propertyNode)).called(1);
        verify(() => mockOnVisitIdentifierNode(identifierNode)).called(1);
        verify(() => mockOnVisitLiteralNode(literalNode)).called(1);
      });
    });

    group('PropertyNode', () {
      test('visitPropertyNode is called when visiting a PropertyNode', () {
        final mockOnVisitPropertyNode =
            _MockSingleArgFunction<void, PropertyNode>(null);
        TestVisitor(
          node: propertyNode,
          onVisitPropertyNode: mockOnVisitPropertyNode.call,
        ).visit();

        verify(() => mockOnVisitPropertyNode(propertyNode)).called(1);
      });
    });
  });
}
