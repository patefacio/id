/// Tests id functionality
///
library id.test.test_id;

import 'package:args/args.dart';
import 'package:id/id.dart';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
// custom <additional imports>
// end <additional imports>

final _logger = new Logger('test_id');

// custom <library test_id>
// end <library test_id>
main([List<String> args]) {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
// custom <main>

  var thrownItem = new isInstanceOf<ArgumentError>();

  common(tn) {
    expect(tn.id, 'test_name');
    expect(tn.snake, 'test_name');
    expect(tn.camel, 'testName');
    expect(tn.capCamel, 'TestName');
    expect(tn.emacs, 'test-name');
    expect(tn.title, 'Test Name');
    expect(tn.shout, 'TEST_NAME');
    expect(tn.squish, 'testname');
    expect(tn.abbrev, 'tn');
  }

  group('basics', () {
    test('default creation (snake)', () {
      common(new Id('test_name'));
      expect(() => new Id('test name'), throwsA(thrownItem));
      expect(() => new Id('testName'), throwsA(thrownItem));
    });

    test('creation from camels', () {
      common(new Id.fromCamels('testName'));
      common(new Id.fromCamels('TestName'));
      expect(() => new Id.fromCamels('test name'), throwsA(thrownItem));
      expect(() => new Id.fromCamels('test_name'), throwsA(thrownItem));
    });

    test('creation from idFromString', () {
      common(idFromString('testName'));
      common(idFromString('test_name'));
      common(idFromString('TestName'));
      expect(idFromString('FOOBAR').snake, 'foobar');
      expect(idFromString('FOO_BAR').snake, 'foo_bar');
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
      expect(Id.isSnake('this_1_is_not_snake'), false);
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
      var id = new Id('how_now_brown_cow');
      expect(id, Id.fromJson(id.toJson()));
    });

  });

// end <main>

}
