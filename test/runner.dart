import 'package:logging/logging.dart';
import 'test_id.dart' as test_id;
import 'test_no_op_id.dart' as test_no_op_id;

void main() {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  test_id.main();
  test_no_op_id.main();
}
