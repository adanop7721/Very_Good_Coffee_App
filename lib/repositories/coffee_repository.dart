import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class CoffeeRepository {
  final String _apiUrl = 'https://coffee.alexflipnote.dev/random.json';

  Future<String> fetchCoffeeImageUrl() async {
    final String jsonUrl =
        kIsWeb ? 'https://corsproxy.io/?url=$_apiUrl' : _apiUrl;

    final response = await http.get(Uri.parse(jsonUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawImageUrl = data['file'];
      final finalImageUrl = kIsWeb
          ? 'https://api.codetabs.com/v1/proxy?quest=$rawImageUrl'
          : rawImageUrl;

      return finalImageUrl;
    } else {
      throw Exception('Failed to load coffee image');
    }
  }
}
