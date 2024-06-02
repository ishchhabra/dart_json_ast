import 'package:json_ast/src/models.dart';

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
    return SourceLocation(line: _line, column: _column);
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

  dynamic _parseValue() {
    _skipWhitespace();
    if (_match('{')) {
      return _parseObject();
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

  ObjectNode _parseObject() {
    final start = _currentLocation();
    _advance(1); // Skip '{'
    _skipWhitespace();
    final properties = <PropertyNode>[];
    while (!_match('}')) {
      _skipWhitespace();
      final key = _parseIdentifier();
      _skipWhitespace();
      _advance(1); // Skip ':'
      _skipWhitespace();
      final value = _parseValue() as ASTNode;
      final span = SourceSpan(
        start: start,
        end: _currentLocation(),
        text: input.substring(start.line, _position),
      );
      properties.add(PropertyNode(key: key, value: value, span: span));
      _skipWhitespace();
      if (_match(',')) {
        _advance(1); // Skip ','
        _skipWhitespace();
      } else {
        break;
      }
    }
    _advance(1); // Skip '}'
    final span = SourceSpan(
      start: start,
      end: _currentLocation(),
      text: input.substring(start.line, _position),
    );
    return ObjectNode(nodes: properties, span: span);
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
    final span = SourceSpan(start: start, end: _currentLocation(), text: value);
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
    final span = SourceSpan(start: start, end: _currentLocation(), text: value);
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
    final span = SourceSpan(start: start, end: _currentLocation(), text: value);
    return LiteralNode(value: num.parse(value), span: span);
  }

  LiteralNode _parseBoolean() {
    final start = _currentLocation();
    if (_match('true')) {
      _advance(4);
      final span =
          SourceSpan(start: start, end: _currentLocation(), text: 'true');
      return LiteralNode(value: true, span: span);
    } else {
      _advance(5);
      final span =
          SourceSpan(start: start, end: _currentLocation(), text: 'false');
      return LiteralNode(value: false, span: span);
    }
  }

  LiteralNode _parseNull() {
    final start = _currentLocation();
    _advance(4);
    final span =
        SourceSpan(start: start, end: _currentLocation(), text: 'null');
    return LiteralNode(value: null, span: span);
  }

  /// Parses the JSON string into an [ObjectNode].
  ObjectNode parse() {
    return _parseObject();
  }
}
