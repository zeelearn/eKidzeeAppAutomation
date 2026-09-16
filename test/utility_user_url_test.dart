import 'package:ekidzee/helper/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utility.resolveDynamicUserPlaceholders', () {
    test('replaces all user placeholders in a URL', () {
      final url =
          'https://example.com/route/<userid>/<uid>/<displayname>/<username>?u=<userid>';

      final resolved = Utility.resolveDynamicUserPlaceholders(
        url,
        userId: '12345',
        uid: 'firebase-uid-67890',
        displayName: 'Jane Doe',
        userName: 'janedoe',
      );

      expect(
        resolved,
        'https://example.com/route/12345/firebase-uid-67890/Jane%20Doe/janedoe?u=12345',
      );
    });

    test('leaves urls unchanged when there are no placeholders', () {
      final url = 'https://example.com/route/public';

      final resolved = Utility.resolveDynamicUserPlaceholders(
        url,
        userId: '12345',
        uid: 'firebase-uid-67890',
        displayName: 'Jane Doe',
        userName: 'janedoe',
      );

      expect(resolved, url);
    });
  });
}
