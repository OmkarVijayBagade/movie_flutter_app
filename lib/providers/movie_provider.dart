import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _popularMovies = [];
  bool _isLoading = true;
  String? _error;

  List<Movie> get popularMovies => _popularMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPopularMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await MovieApiService.fetchPopularMovies();
      _popularMovies = results;
      _popularMovies.shuffle(); // Shuffle the movies for random order
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load movies. Please check your internet connection and try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _popularMovies = [];
    _isLoading = true;
    _error = null;
    notifyListeners();
  }
}