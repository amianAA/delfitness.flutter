import 'package:delfitness/main_local.dart' as main_local;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Local main', () {
    expect(() => main_local.main(), returnsNormally);
  });
}
