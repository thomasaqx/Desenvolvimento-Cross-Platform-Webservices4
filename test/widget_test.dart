import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:checkpoint05_webservices_rm550347/main.dart';

void main() {
  testWidgets('App starts and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Minhas Receitas'), findsOneWidget);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
