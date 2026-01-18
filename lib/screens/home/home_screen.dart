import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/movie_provider.dart';
import '../movie_detail/movie_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  bool _hasAttemptedLoad = false;
  bool _showErrorsAfterDelay = false;

  @override
  void initState() {
    super.initState();
    // Only load movies if not already loaded by splash screen
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (movieProvider.popularMovies.isEmpty && !movieProvider.isLoading && !_hasAttemptedLoad) {
      _hasAttemptedLoad = true;
      movieProvider.loadPopularMovies();
    }

    // Show loading for at least 2 seconds before showing errors
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showErrorsAfterDelay = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, MovieProvider>(
      builder: (context, settings, movieProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Popular Movies'), centerTitle: true),
          body: RefreshIndicator(
            onRefresh: movieProvider.loadPopularMovies,
            child: movieProvider.isLoading || !_showErrorsAfterDelay
                ? const Center(child: CircularProgressIndicator())
                : movieProvider.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie_outlined,
                                size: 80,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No movies available',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movieProvider.error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showErrorsAfterDelay = false;
                                  });
                                  movieProvider.loadPopularMovies();
                                  // Reset the delay timer
                                  Future.delayed(const Duration(seconds: 2), () {
                                    if (mounted) {
                                      setState(() {
                                        _showErrorsAfterDelay = true;
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : movieProvider.popularMovies.isEmpty
                        ? const Center(child: Text('No movies found'))
                        : Column(
                            children: [
                              // Horizontal scrollable movie posters
                              SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  key: ValueKey(Theme.of(context).brightness),
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(12),
                                  itemCount: movieProvider.popularMovies.length + 1, // +1 for the "See More" button
                                  itemBuilder: (context, index) {
                                    if (index == movieProvider.popularMovies.length) {
                                      // Last item: See More button
                                      return Container(
                                        width: 150,
                                        margin: const EdgeInsets.only(left: 12),
                                        child: Center(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              // Navigate to search screen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => const SearchScreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.search),
                                            label: const Text('See More'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    final movie = movieProvider.popularMovies[index];

                                    return Container(
                                      width: 150,
                                      height: 225,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MovieDetailScreen(movie: movie),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            '$imageBaseUrl${movie.posterPath}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Vertical detailed movie cards
                              Expanded(
                                child: ListView.builder(
                                  key: ValueKey('${Theme.of(context).brightness}_vertical'),
                                  padding: const EdgeInsets.all(12),
                                  itemCount: movieProvider.popularMovies.length,
                                  itemBuilder: (context, index) {
                                    final movie = movieProvider.popularMovies[index];

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
                              ),
                            ],
                          ),
          ),
        );
      },
    );
  }
}
