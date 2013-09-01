import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'test_id.dart' as test_id;

void testCore(Configuration config) {
  unittestConfiguration = config;
  main();
}

main() {
  test_id.main();
}

