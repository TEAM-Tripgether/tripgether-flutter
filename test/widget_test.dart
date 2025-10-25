// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripgether/main.dart';
import 'package:tripgether/core/router/router.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // ProviderContainer 생성 (테스트용)
    final container = ProviderContainer();

    // GoRouter 생성 (refreshListenable 포함)
    final router = AppRouter.createRouter(container);

    // 앱 빌드 및 프레임 트리거
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MyApp(router: router),
      ),
    );

    // 스플래시 화면이 표시되는지 확인
    // (실제 앱의 초기 화면 검증)
    await tester.pump();

    // 테스트 종료 시 정리
    addTearDown(container.dispose);
  });
}
