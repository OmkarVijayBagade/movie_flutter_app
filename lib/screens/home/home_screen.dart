import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../services/movie_api_service.dart';
import '../movie_detail/movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  List<Movie> movies = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final results = await MovieApiService.fetchPopularMovies();
      setState(() {
        movies = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = _getErrorMessage(e);
        isLoading = false;
      });
    }
  }

  String _getErrorMessage(Object e) {
    // For debugging, show the actual error
    return 'Error: ${e.toString()}\n\nPlease try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loadMovies,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : movies.isEmpty
                  ? const Center(child: Text('No movies found'))
                  : ListView.builder(
                      key: ValueKey(Theme.of(context).brightness),
                      padding: const EdgeInsets.all(12),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Poster
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    '$imageBaseUrl${movie.posterPath}',
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),

                                // Movie Info
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie.overview,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '⭐ ${movie.rating.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
