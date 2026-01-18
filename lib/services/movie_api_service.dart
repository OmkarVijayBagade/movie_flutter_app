import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_flutter_app/models/genre.dart';
import '../models/movie.dart';

class MovieApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'c46a224bf55a7d9b59889e43d9bcd6dc';

  static Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey');

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List results = decodedData['results'];

      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&query=$query',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search movies: ${response.statusCode}');
    }
  }

  static Future<List<Genre>> fetchGenres() async {
    final url = Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey');

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List genres = data['genres'];

      return genres.map((e) => Genre.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load genres: ${response.statusCode}');
    }
  }

  static Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final url = Uri.parse(
      '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load genre movies: ${response.statusCode}');
    }
  }
}
