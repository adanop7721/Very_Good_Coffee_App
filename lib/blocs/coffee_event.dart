part of 'coffee_bloc.dart';

abstract class CoffeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCoffeeEvent extends CoffeeEvent {}

class SaveCoffeeEvent extends CoffeeEvent {
  final String imageUrl;
  SaveCoffeeEvent(this.imageUrl);
  @override
  List<Object?> get props => [imageUrl];
}

class LoadSavedImagesEvent extends CoffeeEvent {}
