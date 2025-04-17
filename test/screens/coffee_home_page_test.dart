import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:very_good_coffee_app/blocs/coffee_bloc.dart';
import 'package:very_good_coffee_app/screens/coffee_home_page.dart';

class MockCoffeeBloc extends Mock implements CoffeeBloc {}

class FakeCoffeeEvent extends Fake implements CoffeeEvent {}

void main() {
  late CoffeeBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeCoffeeEvent());
  });

  setUp(() {
    mockBloc = MockCoffeeBloc();
  });

  testWidgets('shows loading message when CoffeeLoading state',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(CoffeeLoading());
    whenListen(mockBloc, Stream<CoffeeState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CoffeeBloc>.value(
          value: mockBloc,
          child: const CoffeeHomePage(),
        ),
      ),
    );

    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('shows image and buttons when CoffeeLoaded state',
      (WidgetTester tester) async {
    const testUrl = 'https://coffee.example.com/test.jpg';

    when(() => mockBloc.state).thenReturn(CoffeeLoaded(testUrl));
    whenListen(mockBloc, Stream<CoffeeState>.empty());
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CoffeeBloc>.value(
          value: mockBloc,
          child: const CoffeeHomePage(),
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.text('New Coffee'), findsOneWidget);
    expect(find.text('Save Coffee'), findsOneWidget);
  });

  testWidgets('shows retry button when CoffeeError state',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const CoffeeError("Failed to load image."));
    whenListen(mockBloc, Stream<CoffeeState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CoffeeBloc>.value(
          value: mockBloc,
          child: const CoffeeHomePage(),
        ),
      ),
    );

    expect(find.text("Failed to load image."), findsOneWidget);
    expect(find.text("Retry"), findsOneWidget);
  });

  testWidgets('dispatches LoadCoffeeEvent when "New Coffee" button is tapped',
      (WidgetTester tester) async {
    const testUrl = 'https://coffee.example.com/test.jpg';

    when(() => mockBloc.state).thenReturn(CoffeeLoaded(testUrl));
    whenListen(mockBloc, Stream<CoffeeState>.empty());
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CoffeeBloc>.value(
          value: mockBloc,
          child: const CoffeeHomePage(),
        ),
      ),
    );

    await tester.tap(find.text('New Coffee'));

    final captured = verify(() => mockBloc.add(captureAny())).captured.single;
    expect(captured, isA<LoadCoffeeEvent>());
  });

  testWidgets('dispatches SaveCoffeeEvent when "Save Coffee" button is tapped',
      (WidgetTester tester) async {
    const testUrl = 'https://coffee.example.com/test.jpg';

    when(() => mockBloc.state).thenReturn(CoffeeLoaded(testUrl));
    whenListen(mockBloc, Stream<CoffeeState>.empty());
    when(() => mockBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CoffeeBloc>.value(
          value: mockBloc,
          child: const CoffeeHomePage(),
        ),
      ),
    );

    await tester.tap(find.text('Save Coffee'));
    verify(() => mockBloc.add(SaveCoffeeEvent(testUrl))).called(1);
  });
}
