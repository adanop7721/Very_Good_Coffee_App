import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/blocs/coffee_bloc.dart';
import 'package:very_good_coffee_app/models/coffee_model.dart';
import 'package:very_good_coffee_app/repositories/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeBox extends Mock implements Box<CoffeeImage> {}

void main() {
  late CoffeeBloc bloc;
  late MockCoffeeRepository repository;
  late MockCoffeeBox box;

  setUpAll(() {
    registerFallbackValue(CoffeeImage('fallback'));
  });

  setUp(() {
    repository = MockCoffeeRepository();
    box = MockCoffeeBox();
    when(() => box.values).thenReturn([]);
    bloc = CoffeeBloc(repository: repository, savedBox: box);
  });

  test('initial state is CoffeeInitial', () {
    expect(bloc.state, CoffeeInitial());
  });

  test('emits [CoffeeLoading, CoffeeLoaded] when LoadCoffeeEvent succeeds',
      () async {
    const fakeImageUrl = 'https://example.com/coffee.jpg';

    when(() => repository.fetchCoffeeImageUrl())
        .thenAnswer((_) async => fakeImageUrl);

    bloc.add(LoadCoffeeEvent());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CoffeeLoading>(),
        isA<CoffeeLoaded>().having((s) => s.imageUrl, 'imageUrl', fakeImageUrl),
      ]),
    );
  });

  test('emits [CoffeeLoading, CoffeeError] when LoadCoffeeEvent fails',
      () async {
    when(() => repository.fetchCoffeeImageUrl())
        .thenThrow(Exception('API failed'));

    bloc.add(LoadCoffeeEvent());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CoffeeLoading>(),
        isA<CoffeeError>()
            .having((e) => e.message, 'message', 'Failed to load image.'),
      ]),
    );
  });

  test(
      'adds new image to Hive and emits [CoffeeSaved, CoffeeLoaded] on SaveCoffeeEvent',
      () async {
    const testUrl = 'https://coffee.example.com/123.jpg';

    // No existing saved images
    when(() => box.values).thenReturn([]);
    when(() => box.add(any())).thenAnswer((_) async => 1);

    bloc.add(SaveCoffeeEvent(testUrl));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CoffeeSaved>(),
        isA<CoffeeLoaded>().having((s) => s.imageUrl, 'imageUrl', testUrl),
      ]),
    );
  });

  test(
      'does not add image if already saved and emits [CoffeeSaved, CoffeeLoaded]',
      () async {
    const testUrl = 'https://coffee.example.com/existing.jpg';

    // Simulate image already exists in Hive
    when(() => box.values).thenReturn([
      CoffeeImage(testUrl),
    ]);

    // Should NOT call add
    verifyNever(() => box.add(any()));

    bloc.add(SaveCoffeeEvent(testUrl));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CoffeeSaved>(),
        isA<CoffeeLoaded>().having((s) => s.imageUrl, 'imageUrl', testUrl),
      ]),
    );
  });

  test('emits [CoffeeSavedList] with saved images on LoadSavedImagesEvent',
      () async {
    final savedImages = [
      CoffeeImage('https://coffee.example.com/1.jpg'),
      CoffeeImage('https://coffee.example.com/2.jpg'),
    ];

    when(() => box.values).thenReturn(savedImages);

    bloc.add(LoadSavedImagesEvent());

    await expectLater(
      bloc.stream,
      emits(
        isA<CoffeeSavedList>().having((s) => s.images, 'images', savedImages),
      ),
    );
  });
}
