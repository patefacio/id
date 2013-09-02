import "dart:io";
import "package:path/path.dart" as path;
import "package:ebisu/ebisu_dart_meta.dart";
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

String _topDir;

void main() {

  Logger.root.onRecord.listen(new PrintHandler());
  Logger.root.level = Level.INFO;

  Options options = new Options();
  String here = path.absolute(options.script);
  _topDir = path.dirname(path.dirname(here));
  System ebisu = system('id')
    ..license = 'boost'
    ..includeReadme = true
    ..includeHop = true
    ..pubSpec.homepage = 'https://github.com/patefacio/id'
    ..pubSpec.version = '0.0.2'
    ..pubSpec.doc = 'Library for consistent usage of identifiers'
    ..rootPath = '$_topDir'
    ..doc = 'Provide basic utilities for consistently creating identfiers'
    ..testLibraries = [
      library('test_id')
      ..imports = [
        'package:id/id.dart'
      ]
    ]
    ..libraries = [
      library('id')
      ..doc = '''

Support for consistent use of identifiers.  Identifiers are words used to create
things like class names, variable names, function names, etc. Because different
outputs will want different case conventions for different contexts, using the
Id class allows a simple consistent input format (snake case) to be combined
with the appropriate conventions (usually via templates) to produce consistent
correct naming. Most ebisu entities are named (Libraries, Parts, Classes, etc).

'''
      ..includeLogger = true
      ..variables = [
      ]
      ..enums = [
      ]
      ..imports = [
        'dart:convert'
      ]
      ..classes = [
        class_('id')
        ..doc = "Given an id (all lower case string of words separated by '_')..."
        ..ctorSansNew = true
        ..members = [
          member('id')
          ..doc = "String containing the lower case words separated by '_'"
          ..access = Access.RO
          ..isFinal = true,
          member('words')
          ..doc = "Words comprising the id"
          ..type = 'List<String>'
          ..access = Access.RO
          ..isFinal = true
        ]
      ]
    ];
  ebisu.generate();
}

