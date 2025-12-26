// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutterkvm/features/auth/domain/entities/server_config.dart';
import 'package:flutterkvm/main.dart';
import 'package:flutterkvm/features/video/data/mjpeg_repository.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/atx/domain/atx_status.dart';

class MockMjpegRepository extends Mock implements MjpegRepository {}
class MockAtxRepository extends Mock implements AtxRepository {}

void main() {
  late MockMjpegRepository mockMjpeg;
  late MockAtxRepository mockAtx;
  const testConfig = ServerConfig(
    host: 'localhost',
    username: 'admin',
    password: 'password',
  );

  setUp(() {
    mockMjpeg = MockMjpegRepository();
    mockAtx = MockAtxRepository();

    when(() => mockMjpeg.getVideoStream()).thenAnswer((_) => const Stream.empty());
    when(() => mockAtx.getStatus()).thenAnswer((_) async => const AtxStatus(power: true, hdd: false));
  });

  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DashboardPage(
        config: testConfig,
        mjpegRepository: mockMjpeg,
        atxRepository: mockAtx,
      ),
    ));

    expect(find.text('FlutterKVM - localhost'), findsOneWidget);
    expect(find.text('Power Management'), findsOneWidget);
  });
}
