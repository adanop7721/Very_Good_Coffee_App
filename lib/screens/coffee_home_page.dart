import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/coffee_bloc.dart';
import 'saved_images_page.dart';

class CoffeeHomePage extends StatelessWidget {
  const CoffeeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Very Good Coffee App'),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<CoffeeBloc>().add(LoadSavedImagesEvent());
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SavedImagesPage()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text('Saved'),
            ),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CoffeeBloc, CoffeeState>(
          builder: (context, state) {
            if (state is CoffeeLoading) {
              return const Text('Loading...');
            } else if (state is CoffeeLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: state.imageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return const Text("⚠️ Could not load image");
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      context.read<CoffeeBloc>().add(LoadCoffeeEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      color: Colors.brown,
                      child: const Text('New Coffee',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<CoffeeBloc>()
                          .add(SaveCoffeeEvent(state.imageUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Saved successfully!")),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      color: Colors.green,
                      child: const Text('Save Coffee',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              );
            } else if (state is CoffeeError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      context.read<CoffeeBloc>().add(LoadCoffeeEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text('Retry',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No coffee image loaded."),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.read<CoffeeBloc>().add(LoadCoffeeEvent());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
