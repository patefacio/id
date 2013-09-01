library test_id;

import 'package:id/id.dart';
import 'package:unittest/unittest.dart';

// custom <library test_id>
// end <library test_id>

main() { 
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
    });

    test('capitalize/uncapitalize', () {
      expect(Id.capitalize('this is a test'), 'This is a test');
      expect(Id.uncapitalize('This is a test'), 'this is a test');
      expect(Id.capitalize(' oops'), ' oops');
      expect(Id.uncapitalize(' oops'), ' oops');
    });

    
  });

// end <main>

}
