import 'package:flutter/material.dart';
import 'package:movie_flutter_app/models/genre.dart';
import 'package:provider/provider.dart';
import '../../models/movie.dart';
import '../../services/movie_api_service.dart';
import '../../providers/settings_provider.dart';
import '../movie_detail/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Genre> genres = [];
  int? selectedGenreId;

  @override
  void initState() {
    super.initState();
    loadGenres();
    loadDefaultMovies();
  }

  Future<void> loadGenres() async {
    try {
      final result = await MovieApiService.fetchGenres();
      setState(() {
        genres = result;
      });
    } catch (e) {
      // Fallback to default genres if API fails
      setState(() {
        genres = [
          Genre(id: 28, name: 'Action'),
          Genre(id: 12, name: 'Adventure'),
          Genre(id: 16, name: 'Animation'),
          Genre(id: 35, name: 'Comedy'),
          Genre(id: 80, name: 'Crime'),
          Genre(id: 18, name: 'Drama'),
          Genre(id: 14, name: 'Fantasy'),
          Genre(id: 27, name: 'Horror'),
          Genre(id: 9648, name: 'Mystery'),
          Genre(id: 10749, name: 'Romance'),
          Genre(id: 878, name: 'Sci-Fi'),
          Genre(id: 53, name: 'Thriller'),
        ];
      });
    }
  }

  Future<void> loadDefaultMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await MovieApiService.fetchPopularMovies();
      setState(() {
        fullMovies = results;
        movies = results;
        error = '';
      });
    } catch (e) {
      setState(() {
        error = 'Unable to load movies. Please check your internet connection and try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resetSearch() async {
    _controller.clear();
    selectedGenreId = null;
    await loadDefaultMovies();
  }

  final TextEditingController _controller = TextEditingController();
  List<Movie> movies = [];
  List<Movie> fullMovies = [];
  bool isLoading = false;
  String error = '';

  static const imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<void> search(String query) async {
    if (query.isEmpty) {
      selectedGenreId = null;
      setState(() {
        movies = fullMovies;
        error = '';
      });
      return;
    }

    if (query.length <= 2) {
      // Filter local popular movies for short queries
      setState(() {
        movies = fullMovies
            .where((movie) =>
                movie.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
        isLoading = false;
        error = '';
      });
    } else {
      // API search for longer queries
      setState(() {
        isLoading = true;
        error = '';
        movies = [];
      });

      try {
        final results = await MovieApiService.searchMovies(query);
        setState(() {
          movies = results;
        });
      } catch (e) {
        setState(() {
          error = 'Search failed. Please check your internet connection and try again.';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: RefreshIndicator(
        onRefresh: resetSearch,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: search,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final isSelected = genre.id == selectedGenreId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FilterChip(
                    label: Text(genre.name),
                    selected: isSelected,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    onSelected: (selected) async {
                      setState(() {
                        selectedGenreId = selected ? genre.id : null;
                        error = '';
                      });

                      if (!selected) {
                        await loadDefaultMovies();
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final results = await MovieApiService.fetchMoviesByGenre(
                          genre.id,
                        );

                        setState(() {
                          fullMovies = results;
                          movies = results;
                          isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          error = 'Failed to load movies by genre. Please try again.';
                          isLoading = false;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ),

          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search Unavailable',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        error = '';
                        isLoading = true;
                      });
                      if (selectedGenreId != null) {
                        // Retry loading movies by genre
                        MovieApiService.fetchMoviesByGenre(selectedGenreId!).then((results) {
                          setState(() {
                            fullMovies = results;
                            movies = results;
                            isLoading = false;
                          });
                        }).catchError((e) {
                          setState(() {
                            error = 'Failed to load movies by genre. Please try again.';
                            isLoading = false;
                          });
                        });
                      } else {
                        // Retry loading default movies
                        loadDefaultMovies();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return ListTile(
                  leading: Image.network(
                    '$imageBaseUrl${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
      },
    );
  }
}
