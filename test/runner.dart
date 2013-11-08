import 'utils.dart';
import 'package:unittest/unittest.dart';
import 'test_id.dart' as test_id;

get rootPath => packageRootPath;

void testCore(Configuration config) {
  unittestConfiguration = config;
  main();
}

main() {
  test_id.main();
}

