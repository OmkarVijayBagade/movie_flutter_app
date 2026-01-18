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

  // Fallback movies for when API fails
  final List<Movie> _fallbackMovies = [
    Movie(
      id: 1,
      title: 'Inception',
      overview: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      posterPath: '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
      rating: 8.8,
      releaseDate: '2010-07-16',
    ),
    Movie(
      id: 2,
      title: 'The Dark Knight',
      overview: 'Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets.',
      posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      rating: 9.0,
      releaseDate: '2008-07-18',
    ),
    Movie(
      id: 3,
      title: 'Interstellar',
      overview: 'The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.',
      posterPath: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      rating: 8.6,
      releaseDate: '2014-11-07',
    ),
    Movie(
      id: 4,
      title: 'Parasite',
      overview: 'All unemployed, Ki-taek\'s family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.',
      posterPath: '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      rating: 8.5,
      releaseDate: '2019-05-30',
    ),
    Movie(
      id: 5,
      title: 'The Shawshank Redemption',
      overview: 'Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.',
      posterPath: '/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg',
      rating: 9.3,
      releaseDate: '1994-09-23',
    ),
  ];

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
      // If API fails, use fallback movies
      _popularMovies = List.from(_fallbackMovies);
      _popularMovies.shuffle(); // Shuffle fallback movies too
      _error = null; // Don't show error when using fallback
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