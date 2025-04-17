import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/coffee_bloc.dart';
import 'models/coffee_model.dart';
import 'repositories/coffee_repository.dart';
import 'screens/coffee_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CoffeeImageAdapter());
  final savedBox = await Hive.openBox<CoffeeImage>('savedCoffees');

  runApp(MyApp(savedBox: savedBox));
}

class MyApp extends StatelessWidget {
  final Box<CoffeeImage> savedBox;
  const MyApp({super.key, required this.savedBox});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => CoffeeRepository(),
      child: BlocProvider(
        create: (context) => CoffeeBloc(
          repository: context.read<CoffeeRepository>(),
          savedBox: savedBox,
        )..add(LoadCoffeeEvent()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Very Good Coffee App',
          theme: ThemeData(primarySwatch: Colors.brown),
          home: const CoffeeHomePage(),
        ),
      ),
    );
  }
}
