/// Tests NoOpId functionality
library id.test_no_op_id;

import 'package:id/id.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

// custom <additional imports>
// end <additional imports>

final _logger = new Logger('test_no_op_id');

// custom <library test_no_op_id>
// end <library test_no_op_id>

main([List<String> args]) {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
// custom <main>

  test('id methods on NoOpId', () {
    final s = 'thisIsATest';
    final normalId = idFromString(s);
    final noOpId = new NoOpId(s);

    expect(noOpId.snake, s);
    expect(noOpId.emacs, s);
    expect(noOpId.camel, s);
    expect(noOpId.capCamel, s);
    expect(noOpId.capSnake, s);
    expect(noOpId.shout, s);
    expect(noOpId.title, s);
    expect(noOpId.squish, s);
    expect(noOpId.abbrev, s);
    expect(noOpId.sentence, s);
    expect(noOpId.capSnake, s);
    expect(noOpId.toString(), s);
  });

// end <main>
}
