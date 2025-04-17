part of 'coffee_bloc.dart';

abstract class CoffeeState extends Equatable {
  const CoffeeState();
  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  final String imageUrl;
  const CoffeeLoaded(this.imageUrl);
  @override
  List<Object?> get props => [imageUrl];
}

class CoffeeSaved extends CoffeeState {}

class CoffeeSavedList extends CoffeeState {
  final List<CoffeeImage> images;
  const CoffeeSavedList(this.images);
  @override
  List<Object?> get props => [images];
}

class CoffeeError extends CoffeeState {
  final String message;
  const CoffeeError(this.message);
  @override
  List<Object?> get props => [message];
}
