import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon Section
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(
                    (settings.selectedColor.r * 255).round(),
                    (settings.selectedColor.g * 255).round(),
                    (settings.selectedColor.b * 255).round(),
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: settings.selectedColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.movie,
                  size: 60,
                  color: settings.selectedColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Title and Version
            Center(
              child: Column(
                children: [
                  Text(
                    'Movie Explorer',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // What the App Is For
            Text(
              'About Movie Explorer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Movie Explorer is a comprehensive mobile application designed for movie enthusiasts who want to discover, explore, and keep track of their favorite films. Whether you\'re looking for the latest blockbusters, classic masterpieces, or hidden gems in specific genres, Movie Explorer provides an intuitive and engaging way to browse through an extensive collection of movies.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            Text(
              'Key Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              '🎬 Extensive Movie Database',
              'Access a vast collection of movies with detailed information including plot summaries, cast, ratings, and release dates.',
            ),
            _buildFeatureItem(
              context,
              '🔍 Smart Search & Filtering',
              'Find movies instantly with our advanced search functionality. Filter by genres, discover trending films, or explore movies starting with specific letters.',
            ),
            _buildFeatureItem(
              context,
              '🌙 Dark & Light Themes',
              'Enjoy a personalized viewing experience with multiple theme options and customizable color palettes.',
            ),
            _buildFeatureItem(
              context,
              '📱 Modern Design',
              'Built with Material Design 3 for a sleek, professional, and accessible user interface.',
            ),
            _buildFeatureItem(
              context,
              '⚡ Fast & Responsive',
              'Optimized performance with smooth animations and quick loading times.',
            ),
            const SizedBox(height: 24),

            // Technical Details
            Text(
              'Technical Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(context, 'Platform', 'iOS & Android'),
            _buildInfoItem(context, 'Framework', 'Flutter'),
            _buildInfoItem(context, 'UI Design', 'Material Design 3'),
            _buildInfoItem(context, 'State Management', 'Provider'),
            _buildInfoItem(context, 'Data Source', 'The Movie Database (TMDB) API'),
            _buildInfoItem(context, 'Local Storage', 'Shared Preferences'),
            const SizedBox(height: 24),

            // Privacy & Terms
            Text(
              'Privacy & Terms',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Movie Explorer respects your privacy and does not collect personal information. All movie data is sourced from The Movie Database (TMDB), a free and open movie database. This app is provided as-is for entertainment purposes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),

            // Developer Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.code,
                    size: 48,
                    color: settings.selectedColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Developed by',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Omkar Vijay Bagade',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flutter Developer & UI/UX Enthusiast',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                '© 2026 Movie Explorer. Made with ❤️ using Flutter.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}