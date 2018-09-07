import "dart:io";
import "package:path/path.dart" as path;
import "package:ebisu/ebisu.dart";
import "package:ebisu/ebisu_dart_meta.dart";
import 'package:logging/logging.dart';

String _topDir;

void main() {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;

  useDartFormatter = true;

  String here = path.absolute(Platform.script.toFilePath());
  _topDir = path.dirname(path.dirname(here));
  System ebisu = system('id')
    ..license = 'boost'
    ..pubSpec.author = 'Daniel Davidson <dbdavidson@yahoo.com>'
    ..pubSpec.homepage = 'https://github.com/patefacio/id'
    ..pubSpec.version = '1.0.17'
    ..pubSpec.doc = 'library_ for consistent usage of identifiers'
    ..rootPath = '$_topDir'
    ..doc = 'Provide basic utilities for consistently creating identfiers'
    ..testLibraries = [
      library_('test_id')
        ..doc = '''
Tests id functionality
'''
        ..imports = ['package:id/id.dart'],
      library_('test_no_op_id')
        ..doc = '''
Tests NoOpId functionality
'''
        ..imports = ['package:id/id.dart']
    ]
    ..libraries = [
      library_('id')
        ..doc = '''

Support for consistent use of identifiers.  Identifiers are words used to create
things like class names, variable names, function names, etc. Because different
outputs will want different case conventions for different contexts, using the
Id class allows a simple consistent input format (snake case) to be combined
with the appropriate conventions (usually via templates) to produce consistent
correct naming. Most ebisu entities are named (Libraries, Parts, Classes, etc).

'''
        ..includesLogger = true
        ..imports = ['dart:convert']
        ..classes = [
          class_('id')
            ..doc =
                "Given an id (all lower case string of words separated by '_')..."
            ..hasOpEquals = true
            ..implement = ['Comparable<Id>']
            ..members = [
              member('id')
                ..doc =
                    "String containing the lower case words separated by '_'"
                ..access = Access.RO
                ..isFinal = true,
              member('words')
                ..doc = "Words comprising the id"
                ..type = 'List<String>'
                ..access = Access.RO
                ..isFinal = true
            ],
          class_('no_op_id')
            ..implement = ['Id']
            ..doc = '''
Supports the same interface as Id but all transformations like [camel], [snake],
... resolve to no-ops.

This provides the ability to circumvent hard *Id* casing rules in certain
circumstances.
'''
            ..defaultMemberAccess = RO
            ..members = [
              member('id')
                ..doc =
                    "String containing the lower case words separated by '_'"
                ..isOverride = true
                ..isFinal = true,
              member('words')
                ..doc = "Words comprising the id"
                ..type = 'List<String>'
                ..isOverride = true
                ..isFinal = true
            ],
          class_('id_trailing_underscore') 
          ..doc = '''
Id-like object with special overrides for [snake], [emacs], [camel], [capCamel]
and [capSnake] which end in *unserscore* (or *hyphen* for emacs). The purpose is
to support special *terms* that conflict with keywords in target languages (e.g.
String -> String_)'''
           ..extend = 'Id'
        ]
    ];
  ebisu.generate(generateDrudge:false);
}
