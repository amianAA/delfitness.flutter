import 'package:delfitness/common/repositories/user/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Models', () {
    test('User fromJson method', () {
      final Map<String, dynamic> userData = {
        "id": 1,
        "username": "test",
        "email": 'test@email.com',
        "first_name": 'Pepe',
        "last_name": 'García',
      };

      User user = User.fromJson(userData);
      expect(user.id, 1);
      expect(user.username, "test");
      expect(user.email, "test@email.com");
      expect(user.firstName, "Pepe");
      expect(user.lastName, "García");
    });
  });
}
