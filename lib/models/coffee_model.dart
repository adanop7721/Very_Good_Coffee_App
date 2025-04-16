import 'package:hive/hive.dart';

part 'coffee_model.g.dart';

@HiveType(typeId: 0)
class CoffeeImage extends HiveObject {
  @HiveField(0)
  final String imageUrl;

  CoffeeImage(this.imageUrl);
}
