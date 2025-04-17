import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../blocs/coffee_bloc.dart';

class SavedImagesPage extends StatelessWidget {
  const SavedImagesPage({super.key});

  String corsSafeUrl(String url) {
    if (!kIsWeb) return url;

    // Prevent double-proxying if already using a CORS proxy
    if (url.contains('codetabs.com') || url.contains('corsproxy.io')) {
      return url;
    }

    return 'https://api.codetabs.com/v1/proxy?quest=$url';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoffeeBloc>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Coffees')),
      body: state is CoffeeSavedList
          ? ListView.builder(
              itemCount: state.images.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: corsSafeUrl(state.images[index].imageUrl),
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Text("⚠️ Failed to load image"),
                  ),
                );
              },
            )
          : const Center(child: Text('No saved coffees found.')),
    );
  }
}
