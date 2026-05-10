import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/theme_cubit/theme_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/dark_mode_toggle_row.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/fake_theme_services.dart';

Future<FakeThemeServices> _pumpToggle(
  WidgetTester tester, {
  required bool initialIsDark,
}) async {
  final service = FakeThemeServices();
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => ThemeCubit(
          themeServices: service,
          initialIsDark: initialIsDark,
        ),
        child: const Scaffold(
          body: DarkModeToggleRow(),
        ),
      ),
    ),
  );
  return service;
}

void main() {
  testWidgets('renders a Switch widget', (tester) async {
    await _pumpToggle(tester, initialIsDark: false);

    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('Switch value is false in light mode', (tester) async {
    await _pumpToggle(tester, initialIsDark: false);

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

  testWidgets('Switch value is true in dark mode', (tester) async {
    await _pumpToggle(tester, initialIsDark: true);

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('tapping the switch calls toggle callback', (tester) async {
    final service = await _pumpToggle(tester, initialIsDark: false);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(service.saveCallCount, 1);
  });

  testWidgets('has Dark mode semantics with toggled value', (tester) async {
    await _pumpToggle(tester, initialIsDark: true);

    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Dark mode',
      ),
    );
    expect(semantics.properties.label, 'Dark mode');
    expect(semantics.properties.toggled, isTrue);
  });

  testWidgets('shows sun icon in light mode and moon icon in dark mode',
      (tester) async {
    await _pumpToggle(tester, initialIsDark: false);

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await _pumpToggle(tester, initialIsDark: true);

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    expect(find.byIcon(Icons.light_mode), findsNothing);
  });
}
