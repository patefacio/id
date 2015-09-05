/// 
/// Support for consistent use of identifiers.  Identifiers are words used to create
/// things like class names, variable names, function names, etc. Because different
/// outputs will want different case conventions for different contexts, using the
/// Id class allows a simple consistent input format (snake case) to be combined
/// with the appropriate conventions (usually via templates) to produce consistent
/// correct naming. Most ebisu entities are named (Libraries, Parts, Classes, etc).
library id.id;

import 'dart:convert';
import 'package:collection/equality.dart';
import 'package:logging/logging.dart';
import 'package:quiver/core.dart';

// custom <additional imports>
// end <additional imports>

final _logger = new Logger('id');

/// Given an id (all lower case string of words separated by '_')...
class Id
  implements Comparable<Id> {

  bool operator==(Id other) =>
    identical(this, other) ||
    _id == other._id &&
    const ListEquality().equals(_words, other._words);

  int get hashCode => hash2(_id, const ListEquality<String>().hash(_words));

  /// String containing the lower case words separated by '_'
  String get id => _id;
  /// Words comprising the id
  List<String> get words => _words;

  // custom <class Id>

  /// `id` must be a string in snake case (e.g. `how_now_brown_cow`)
  Id(String id) :
    _id = id,
    _words = id.split('_')
  {
    if(null != _hasUpperRe.firstMatch(id)) {
      throw new ArgumentError("Id must be lower case $id");
    }
    if(null == _validSnakeRe.firstMatch(id)) {
      throw new ArgumentError("Id has invalid characters $id");
    }
  }

  Id.fromCamels(String camelId) : this(splitCamelHumps(camelId));

  static Id idFromCamels(String camelId) => new Id.fromCamels(camelId);

  static bool isCamel(String text) => _camelRe.firstMatch(text) != null;
  static bool isCapCamel(String text) => _capCamelRe.firstMatch(text) != null;
  static bool isSnake(String text) => _snakeRe.firstMatch(text) != null;
  static bool isCapSnake(String text) => _capSnakeRe.firstMatch(text) != null;
  static bool isAllCap(String text) => _allCapRe.firstMatch(text) != null;

  static RegExp _capCamelRe = new RegExp(r'^[A-Z][A-Za-z\d]*$');
  static RegExp _camelRe = new RegExp(r'^(?:[A-Za-z]+[a-z\d]*)+$');
  static RegExp _snakeRe = new RegExp(r'^[a-z]+[a-z\d]*(?:_[a-z\d]+)*$');
  static RegExp _capSnakeRe = new RegExp(r'^[A-Z][a-z\d]*(?:_[a-z\d]+)*$');
  static RegExp _capWordDelimiterRe = new RegExp('[A-Z]');
  static RegExp _allCapRe = new RegExp(r'^[A-Z][A-Z_\d]+$');
  static RegExp _leadingTrailingUnderbarRe = new RegExp(r'(?:^_)|(?:_$)');

  static String splitCamelHumps(String text) {
    if(text.indexOf('_') >=0) {
      throw new ArgumentError("Camels can not have underscore: $text");
    }

    var result =
      text.splitMapJoin(_capWordDelimiterRe,
          onMatch: (Match match) => match.group(0).toLowerCase(),
          onNonMatch: (String nonMatch) => nonMatch + '_')
      .replaceAll(_leadingTrailingUnderbarRe, '');
    return result;
  }

  static final RegExp _hasUpperRe = new RegExp(r"[A-Z]");
  static final RegExp _validSnakeRe = new RegExp(r"^[a-z][a-z\d_]*$");

  /// Capitalize the string (i.e. make first character capital, leaving rest alone)
  static capitalize(String s) => "${s[0].toUpperCase()}${s.substring(1)}";

  /// Unapitalize the string (i.e. make first character lower, leaving rest alone)
  static uncapitalize(String s) => "${s[0].toLowerCase()}${s.substring(1)}";

  /// Return this id as snake case - (i.e. the case passed in for construction) (e.g. `how_now_brown_cow`)
  String get snake => _id;
  /// Return this id as hyphenated words (e.g. `how_now_brown_cow` => `how-now-brown-cow`)
  String get emacs => _words.join('-');
  /// Return as camel case, first character lower and each word capitalized (e.g. `how_now_brown_cow` => `howNowBrownCow`)
  String get camel => uncapitalize(_words.map((w) => capitalize(w)).join(''));
  /// Return as cap camel case, same as camel with first word capitalized (e.g. `how_now_brown_cow` => `HowNowBrownCow`)
  String get capCamel => _words.map((w) => capitalize(w)).join('');
  /// Return snake case capitalized (e.g. `how_now_brown_cow` => 'How_now_brown_cow`)
  String get capSnake => capitalize(snake);
  /// Return all caps with underscore separator (e.g. `how_now_brown_cow` => `HOW_NOW_BROWN_COW`)
  String get shout => _words.map((w) => w.toUpperCase()).join('_');
  /// Return each word capitalized with space `' '` separator (e.g. `how_now_brown_cow` => `How Now Brown Cow`)
  String get title => _words.map((w) => capitalize(w)).join(' ');
  /// Return words squished together with no separator (e.g. `how_now_brown_cow` => `hownowbrowncow`)
  String get squish => _words.join('');
  /// Return first letter of each word joined together (e.g. `how_now_brown_cow` => `hnbc`)
  String get abbrev => _words.map((w) => w[0]).join();
  /// Return the words joined with spaces like a sentence only (without first word capitalized)
  String get sentence => _words.join(' ');

  /// Return new id as the plural of the argument (`Id('dog')` => `Id('dogs')`)
  static Id pluralize(Id id, [ String suffix = 's' ]) => new Id(id._id + suffix);

  String toString() => camel;

  toJson() => JSON.encode({"id" : _id});

  static Id fromJson(String json) {
    Map jsonMap = JSON.decode(json);
    return fromJsonMap(jsonMap);
  }

  static Id fromJsonMap(Map jsonMap) {
    return new Id(jsonMap["id"]);
  }


  int compareTo(Id other) => id.compareTo(other._id);

  // end <class Id>

  final String _id;
  final List<String> _words;

}

// custom <library id>

/// Create an [Id] from text
///
/// Provides a heuristic to turn a string into an [Id] where individual words
/// are identified.
///
/// For example, each of the following print *[ 'this', 'is', 'a', 'test' ]*
///
///     print(idFromString('thisIsATest').words);
///     print(idFromString('this_is_a_test').words);
///     print(idFromString('ThisIsATest').words);
///     print(idFromString('This_is_a_test').words);
///     print(idFromString('THIS_IS_A_TEST').words);
///
Id idFromString(String text) =>
    Id.isSnake(text)?
    new Id(text) :
    (Id.isAllCap(text)? idFromString(text.toLowerCase()) :
        (Id.isCamel(text)? new Id.fromCamels(text) :
            (Id.isCapSnake(text)? new Id(text.toLowerCase()) :
                throw new ArgumentError("$text is neither snake or camel"))));

final _whiteSpaceRe = new RegExp(r'\s+');

/// Create an [Id] from a sentence like string of white-space delimited words
///
/// For example, each of the following print *[ 'this', 'is', 'a', 'test' ]*
///
///     print(idFromWords('this is a test').words);
///     print(idFromWords('This is a test').words);
///     print(idFromWords('  THIS IS A TEST  ').words);
///
Id idFromWords(String words) =>
  idFromString(words.trim().replaceAll(_whiteSpaceRe, '_'));

final _capSubstring = new RegExp(r'([A-Z]+)([A-Z]|$)');

///
/// Given a camel case word [s] with all cap abbreviations embedded, converts
/// the abbreviations to camel.
///
/// e.g.  capSubstringToCamel('CIASpy') -> 'CiaSpy'
///
capSubstringToCamel(String s) => s.replaceAllMapped(
    _capSubstring, (Match m) => '${Id.capitalize(m[1].toLowerCase())}${m[2]}');

// end <library id>


