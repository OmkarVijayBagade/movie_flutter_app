import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'c46a224bf55a7d9b59889e43d9bcd6dc';

  static Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List results = decodedData['results'];

      return results
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}