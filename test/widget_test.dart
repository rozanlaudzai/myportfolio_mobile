import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportfolio_mobile/main.dart';
import 'package:myportfolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Guests can browse projects and must sign in to add one', (
    tester,
  ) async {
    var created = false;
    var loggedOut = false;
    final api = ApiClient(
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          expect(jsonDecode(request.body), {
            'username': 'owner',
            'password': 'test',
          });
          return http.Response('{"token":"test-token"}', 200);
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.headers['Authorization'], 'Token test-token');
          loggedOut = true;
          return http.Response('', 204);
        }
        expect(request.url.path, '/api/v1/projects/');
        if (request.method == 'POST') {
          expect(request.headers['Authorization'], 'Token test-token');
          final project = jsonDecode(request.body) as Map<String, dynamic>;
          expect(project, {
            'title': 'Flutter client',
            'description': 'New mobile project',
            'tech_stack': 'Flutter',
            'project_url': '',
            'project_image_url': '',
          });
          created = true;
          return http.Response(jsonEncode({...project, 'id': 'new-uuid'}), 201);
        }
        expect(request.headers['Authorization'], isNull);
        return http.Response(
          '[{"id":"uuid","title":"Portfolio site","description":"Project description",'
          '"tech_stack":"Django","project_url":""}]',
          200,
        );
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(MyApp(apiClient: api));

    await tester.tap(find.text('Show Projects'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio site'));
    await tester.pumpAndSettle();
    expect(find.text('Project description'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a Project'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
    await tester.enterText(find.byType(TextFormField).at(0), 'owner');
    await tester.enterText(find.byType(TextFormField).at(1), 'test');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Tech Stack'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Flutter client');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'New mobile project',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter');
    final save = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(created, isTrue);
    expect(find.text('Project added'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Logout'));
    await tester.pumpAndSettle();
    expect(loggedOut, isTrue);
    expect(find.text('Signed out.'), findsOneWidget);
  });
}
