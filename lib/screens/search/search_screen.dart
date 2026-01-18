import 'package:flutter/material.dart';
import 'package:movie_flutter_app/models/genre.dart';
import '../../models/movie.dart';
import '../../services/movie_api_service.dart';
import '../movie_detail/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<Genre> genres = [];

int? selectedGenreId;

class _SearchScreenState extends State<SearchScreen> {
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
      // Handle error, perhaps show a message or retry
      setState(() {
        error = 'Failed to load genres';
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
        error = 'Failed to load movies';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          error = 'Something went wrong';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
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
                    onSelected: (selected) async {
                      setState(() {
                        selectedGenreId = selected ? genre.id : null;
                        isLoading = true;
                        error = '';
                      });

                      if (!selected) {
                        await loadDefaultMovies();
                        return;
                      }

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
                          error = 'Failed to load movies by genre';
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
            Padding(padding: const EdgeInsets.all(20), child: Text(error)),

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
    );
  }
}
