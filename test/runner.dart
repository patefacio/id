import 'package:unittest/unittest.dart';
import 'package:logging/logging.dart';
import 'test_id.dart' as test_id;

void testCore(Configuration config) {
  unittestConfiguration = config;
  main();
}

main() {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  test_id.main();
}

