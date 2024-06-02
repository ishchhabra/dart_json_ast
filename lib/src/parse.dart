import 'package:json_ast/src/json_ast.dart';
import 'package:json_ast/src/models.dart';
import 'package:source_span/source_span.dart';

/// A class that parses JSON strings into AST.
class JsonParser {
  /// Creates a new [JsonParser] instance.
  JsonParser(this.input)
      : _length = input.length,
        _position = 0,
        _line = 1,
        _column = 1;

  /// The JSON string to parse.
  final String input;

  final int _length;
  int _position;
  int _line;
  int _column;

  SourceLocation _currentLocation() {
    return SourceLocation(_position, line: _line, column: _column);
  }

  void _advance(int length) {
    for (var i = 0; i < length; i++) {
      if (input[_position] == '\n') {
        _line++;
        _column = 1;
      } else {
        _column++;
      }
      _position++;
    }
  }

  bool _match(String pattern) {
    return input.startsWith(pattern, _position);
  }

  void _skipWhitespace() {
    while (_position < _length &&
        (input[_position] == ' ' ||
            input[_position] == '\t' ||
            input[_position] == '\n' ||
            input[_position] == '\r')) {
      _advance(1);
    }
  }

  ASTNode _parseValue() {
    _skipWhitespace();
    if (_match('{')) {
      return _parseObject();
    } else if (_match('[')) {
      return _parseArray();
    } else if (_match('"')) {
      return _parseString();
    } else if (_match('t') || _match('f')) {
      return _parseBoolean();
    } else if (_match('n')) {
      return _parseNull();
    } else {
      return _parseNumber();
    }
  }

  ArrayNode _parseArray() {
    final start = _currentLocation();
    _advance(1); // Skip '['
    _skipWhitespace();
    final nodes = <ASTNode>[];
    while (!_match(']')) {
      _skipWhitespace();
      final node = _parseValue();
      nodes.add(node);
      _skipWhitespace();
      if (_match(',')) {
        _advance(1); // Skip ','
        _skipWhitespace();
      } else {
        break;
      }
    }
    _advance(1); // Skip ']'
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return ArrayNode(nodes: nodes, span: span);
  }

  ObjectNode _parseObject() {
    final start = _currentLocation();
    _advance(1); // Skip '{'
    _skipWhitespace();
    final properties = <PropertyNode>[];
    while (!_match('}')) {
      _skipWhitespace();
      final property = _parseProperty();
      properties.add(property);
      _skipWhitespace();
      if (_match(',')) {
        _advance(1); // Skip ','
        _skipWhitespace();
      } else {
        break;
      }
    }
    _advance(1); // Skip '}'
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return ObjectNode(nodes: properties, span: span);
  }

  PropertyNode _parseProperty() {
    final start = _currentLocation();
    final key = _parseIdentifier();
    _skipWhitespace();
    _advance(1); // Skip ':'
    _skipWhitespace();
    final value = _parseValue();
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return PropertyNode(key: key, value: value, span: span);
  }

  IdentifierNode _parseIdentifier() {
    final start = _currentLocation();
    _advance(1); // Skip initial '"'
    final stringStart = _position;
    while (!_match('"')) {
      _advance(1);
    }
    final value = input.substring(stringStart, _position);
    _advance(1); // Skip closing '"'
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return IdentifierNode(value: value, span: span);
  }

  LiteralNode _parseString() {
    final start = _currentLocation();
    _advance(1); // Skip initial '"'
    final stringStart = _position;
    while (!_match('"')) {
      _advance(1);
    }
    final value = input.substring(stringStart, _position);
    _advance(1); // Skip closing '"'
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return LiteralNode(value: value, span: span);
  }

  LiteralNode _parseNumber() {
    final start = _currentLocation();
    final numberStart = _position;
    while (_position < _length &&
        (input[_position].contains(RegExp('[0-9]')) ||
            input[_position] == '.')) {
      _advance(1);
    }
    final value = input.substring(numberStart, _position);
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return LiteralNode(value: num.parse(value), span: span);
  }

  LiteralNode _parseBoolean() {
    final start = _currentLocation();
    if (_match('true')) {
      _advance(4);
      final end = _currentLocation();
      final text = input.substring(start.offset, end.offset);
      final span = SourceSpan(start, end, text);
      return LiteralNode(value: true, span: span);
    } else {
      _advance(5);
      final end = _currentLocation();
      final text = input.substring(start.offset, end.offset);
      final span = SourceSpan(start, end, text);
      return LiteralNode(value: false, span: span);
    }
  }

  LiteralNode _parseNull() {
    final start = _currentLocation();
    _advance(4);
    final end = _currentLocation();
    final text = input.substring(start.offset, end.offset);
    final span = SourceSpan(start, end, text);
    return LiteralNode(value: null, span: span);
  }

  /// Parses the JSON string into an [ObjectNode].
  ASTNode parse() {
    return _parseValue();
  }
}
