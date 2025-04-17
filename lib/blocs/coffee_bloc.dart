import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/coffee_repository.dart';
import '../models/coffee_model.dart';
import 'package:hive/hive.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final CoffeeRepository repository;
  final Box<CoffeeImage> savedBox;

  CoffeeBloc({required this.repository, required this.savedBox})
      : super(CoffeeInitial()) {
    on<LoadCoffeeEvent>(_onLoadCoffee);
    on<SaveCoffeeEvent>(_onSaveCoffee);
    on<LoadSavedImagesEvent>(_onLoadSavedImages);
  }

  Future<void> _onLoadCoffee(
      LoadCoffeeEvent event, Emitter<CoffeeState> emit) async {
    emit(CoffeeLoading());
    try {
      final imageUrl = await repository.fetchCoffeeImageUrl();
      emit(CoffeeLoaded(imageUrl));
    } catch (e, stackTrace) {
      print('[CoffeeBloc] ERROR: $e');
      print(stackTrace);
      emit(const CoffeeError("Failed to load image."));
    }
  }

  Future<void> _onSaveCoffee(
      SaveCoffeeEvent event, Emitter<CoffeeState> emit) async {
    final exists = savedBox.values.any((img) => img.imageUrl == event.imageUrl);
    if (!exists) {
      await savedBox.add(CoffeeImage(event.imageUrl));
    }
    emit(CoffeeSaved());
    emit(CoffeeLoaded(event.imageUrl));
  }

  Future<void> _onLoadSavedImages(
      LoadSavedImagesEvent event, Emitter<CoffeeState> emit) async {
    emit(CoffeeSavedList(savedBox.values.toList()));
  }
}
