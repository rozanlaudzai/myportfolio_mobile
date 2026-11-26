import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportfolio_mobile/main.dart';
import 'package:myportfolio_mobile/models/award.dart';
import 'package:myportfolio_mobile/services/api_client.dart';

void main() {
  test('Award reads server fields and sends a date-only write payload', () {
    final award = Award.fromJson({
      'id': 'server-id',
      'title': 'Merit Award',
      'issuer': 'University',
      'description': 'Academic recognition',
      'awarded_at': '2026-06-30',
      'star_count': 2,
      'is_starred': true,
      'starred_by_names': null,
    });

    expect(award.id, 'server-id');
    expect(award.starCount, 2);
    expect(award.isStarred, isTrue);
    expect(award.starredByNames, isEmpty);
    expect(award.toJson(), {
      'title': 'Merit Award',
      'issuer': 'University',
      'description': 'Academic recognition',
      'awarded_at': '2026-06-30',
    });
  });

  testWidgets(
    'Awards retry, reauthenticate after 401, and reload after saving',
    (tester) async {
      var reads = 0;
      var logins = 0;
      var writes = 0;
      var revocationChecks = 0;
      final records = <Map<String, dynamic>>[
        {
          'id': 'existing-award-id',
          'title': 'Merit Award',
          'issuer': 'University',
          'description': 'Academic recognition',
          'awarded_at': '2026-06-30',
        },
      ];
      final client = ApiClient(
        client: MockClient((request) async {
          switch ((request.method, request.url.path)) {
            case ('GET', '/api/v1/awards/'):
              expect(request.headers['Authorization'], isNull);
              reads++;
              if (reads == 1) return http.Response('', 503);
              return http.Response(jsonEncode(records), 200);
            case ('POST', '/api/v1/auth/token/'):
              logins++;
              return http.Response(jsonEncode({'token': 'token-$logins'}), 200);
            case ('POST', '/api/v1/auth/logout/'):
              expect(request.headers['Authorization'], 'Token token-1');
              revocationChecks++;
              return http.Response('', 401);
            case ('POST', '/api/v1/awards/'):
              writes++;
              expect(request.headers['Authorization'], 'Token token-$writes');
              final data = jsonDecode(request.body) as Map<String, dynamic>;
              expect(
                data.keys,
                unorderedEquals([
                  'title',
                  'issuer',
                  'description',
                  'awarded_at',
                ]),
              );
              expect(data['title'], 'Mobile award');
              expect(data['issuer'], 'Flutter club');
              expect(data['description'], 'Saved after reauthenticating');
              expect(data['awarded_at'], matches(r'^\d{4}-\d{2}-\d{2}$'));
              if (writes == 1) return http.Response('', 401);
              final award = {...data, 'id': 'new-award-id'};
              records.insert(0, award);
              return http.Response(jsonEncode(award), 201);
            default:
              fail('Unexpected request: ${request.method} ${request.url.path}');
          }
        }),
      );
      addTearDown(client.close);
      await tester.pumpWidget(MyApp(apiClient: client));

      await tester.ensureVisible(find.text('Show Awards'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show Awards'));
      await tester.pumpAndSettle();
      expect(find.text('Could not load awards.'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(reads, 2);
      await tester.tap(find.text('Merit Award'));
      await tester.pumpAndSettle();
      expect(find.text('Academic recognition'), findsOneWidget);
      expect(find.text('2026-06-30'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      Future<void> signIn() async {
        expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
        await tester.enterText(find.byType(TextFormField).at(0), 'owner');
        await tester.enterText(find.byType(TextFormField).at(1), 'password');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byTooltip('Add award'));
      await tester.pumpAndSettle();
      await signIn();
      await tester.enterText(find.byType(TextFormField).at(0), 'Mobile award');
      await tester.enterText(find.byType(TextFormField).at(1), 'Flutter club');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'Saved after reauthenticating',
      );
      final date = find.text('Select award date');
      await tester.ensureVisible(date);
      await tester.tap(date);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      final save = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(writes, 1);
      expect(revocationChecks, 1);
      await signIn();

      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(writes, 2);
      expect(find.text('Award added'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      expect(reads, 3);
      expect(find.text('Mobile award'), findsOneWidget);
    },
  );
}
