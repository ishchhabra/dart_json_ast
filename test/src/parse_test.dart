import 'dart:convert';

import 'package:json_ast/json_ast.dart';
import 'package:test/test.dart';

void main() {
  group('JsonParser', () {
    group('ArrayNode', () {
      test('parses an empty array properly', () {
        final input = <void>[];
        final parser = JsonParser(jsonEncode(input));
        final ast = parser.parse();

        expect(ast, isA<ArrayNode>());

        ast as ArrayNode;
        expect(ast.nodes, isEmpty);
      });
    });

    group('ObjectNode', () {
      test('parses an empty object properly', () {
        final input = <String, dynamic>{};
        final parser = JsonParser(jsonEncode(input));
        final ast = parser.parse();

        expect(ast, isA<ObjectNode>());

        ast as ObjectNode;
        expect(ast.nodes, isEmpty);
      });

      test('parses a simple object properly', () {
        final input = <String, String>{'hello': 'world'};
        final parser = JsonParser(jsonEncode(input));
        final ast = parser.parse();

        expect(ast, isA<ObjectNode>());

        ast as ObjectNode;
        expect(ast.nodes, hasLength(1));

        final node = ast.nodes.first;
        expect(node, isA<PropertyNode>());

        node as PropertyNode;

        final key = node.key;
        expect(key.value, 'hello');

        final value = node.value;
        expect(value, isA<LiteralNode>());
        value as LiteralNode;
        expect(value.value, 'world');
      });
    });
  });
}
