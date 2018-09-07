/// Tests id functionality
library id.test_id;

import 'package:id/id.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>
// end <additional imports>

final Logger _logger = new Logger('test_id');

// custom <library test_id>
// end <library test_id>

void main([List<String> args]) {
  if (args?.isEmpty ?? false) {
    Logger.root.onRecord.listen(
        (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
    Logger.root.level = Level.OFF;
  }
// custom <main>

  isInstanceOf<ArgumentError> thrownItem = new isInstanceOf<ArgumentError>();

  void _common(Id tn) {
    expect(tn.id, 'test_name');

    expect(tn.abbrev, 'tn');
    expect(tn.camel, 'testName');
    expect(tn.capCamel, 'TestName');
    expect(tn.emacs, 'test-name');
    expect(tn.sentence, 'test name');
    expect(tn.shout, 'TEST_NAME');
    expect(tn.snake, 'test_name');
    expect(tn.squish, 'testname');
    expect(tn.title, 'Test Name');
  }

  group('basics', () {
    test('default creation (snake)', () {
      _common(new Id('test_name'));
      expect(() => new Id('test name'), throwsA(thrownItem));
      expect(() => new Id('testName'), throwsA(thrownItem));
    });

    test('creation from camels', () {
      _common(new Id.fromCamels('testName'));
      _common(new Id.fromCamels('TestName'));
      expect(() => new Id.fromCamels('test name'), throwsA(thrownItem));
      expect(() => new Id.fromCamels('test_name'), throwsA(thrownItem));
    });

    test('creation from idFromString/idFromWords', () {
      _common(idFromString('testName'));
      _common(idFromString('test_name'));
      _common(idFromString('TestName'));
      expect(idFromString('FOOBAR').snake, 'foobar');
      expect(idFromString('FOO_BAR').snake, 'foo_bar');
      expect(idFromWords('this is a test').snake, 'this_is_a_test');
      expect(idFromWords(' this   is a test  ').snake, 'this_is_a_test');
      expect(idFromWords('this is a test').snake, 'this_is_a_test');
      expect(idFromWords('THIS   IS A TEST  ').snake, 'this_is_a_test');
    });

    group('words starting with number', () {
      test('allowed in Id ctor', () {
        expect(new Id('a_1').toString(), 'a1');
        expect(idFromString('A_1_a_a').snake, 'a_1_a_a');
      });

      test('not allowed in idFromString', () {
        expect(() => idFromString('a__'), throws);
        expect(() => idFromString('A__'), throws);
        expect(() => idFromString('A_1_'), throws);
        expect(() => idFromString('A_1_a_A'), throws);
      });
    });

    test('isCamel identification', () {
      expect(Id.isCamel('ThisIsCamel'), true);
      expect(Id.isCamel('thisIsCamel'), true);
      expect(Id.isCamel('this_Is_Not_Camel'), false);
      expect(Id.isCamel('thisIsNot Camel'), false);
      expect(Id.isCapCamel('ThisIsCapCamel'), true);
      expect(Id.isCapCamel('thisIsNotCapCamel'), false);
      expect(Id.isSnake('this_is_snake'), true);
      expect(Id.isSnake('this_is_not_Snake'), false);
      expect(Id.isSnake('this_1_is_snake'), true);
      expect(Id.isSnake('this1_is_nake'), true);

      expect(Id.isCamel('This1isCamel'), true);
      expect(Id.isCamel('3ThisisCamel'), false);
    });

    test('capitalize/uncapitalize', () {
      expect(Id.capitalize('this is a test'), 'This is a test');
      expect(Id.uncapitalize('This is a test'), 'this is a test');
      expect(Id.capitalize(' oops'), ' oops');
      expect(Id.uncapitalize(' oops'), ' oops');
    });

    test('==', () {
      expect(new Id('one_two_three'), idFromString('oneTwoThree'));
      expect(new Id('one_two_three') != idFromString('threeTwoOne'), true);
    });

    test('json', () {
      Id id = new Id('how_now_brown_cow');
      expect(id, Id.fromJson(id.toJson()));
    });

    test('capSubstringToCamel', () {
      expect(capSubstringToCamel('shouldFixABC'), 'shouldFixAbc');
      expect(capSubstringToCamel('ABCDE'), 'Abcde');
      expect(capSubstringToCamel('ABCDEFoobar'), 'AbcdeFoobar');
      expect(capSubstringToCamel('gooFOOMoo'), 'gooFooMoo');
      expect(capSubstringToCamel('CIASpy'), 'CiaSpy');
    });

    test('idTrailingUnderscore', () {
      makeId(dynamic id) => new IdTrailingUnderscore(id);
      expect(makeId('simple_test').capCamel, 'SimpleTest_');
      expect(makeId('simple_test').camel, 'simpleTest_');
      expect(makeId('simple_test').snake, 'simple_test_');
      expect(makeId('simple_test').capSnake, 'Simple_test_');
      expect(makeId('simple_test').emacs, 'simple-test-');

      expect(idTrailingUnderscore('simple_test').emacs, 'simple-test-');
    });
  });

// end <main>
}
