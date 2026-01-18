import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Theme'),
                  const SizedBox(height: 8),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.brightness_5),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.brightness_2),
                      ),
                    ],
                    selected: {settings.themeMode},
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            final brightness = Theme.of(context).brightness;
                            return brightness == Brightness.dark ? Colors.white : null;
                          }
                          return null;
                        },
                      ),
                    ),
                    onSelectionChanged: (Set<ThemeMode> selected) {
                      settings.setThemeMode(selected.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Color Palette'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(settings.colors.length, (index) {
                      final color = settings.colors[index];
                      final isSelected = index == settings.selectedColorIndex;
                      return GestureDetector(
                        onTap: () {
                          settings.setSelectedColorIndex(index);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Preferences Section
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Adult Content'),
                  subtitle: const Text('Include adult movies in search results'),
                  value: settings.showAdultContent,
                  onChanged: (value) {
                    settings.setShowAdultContent(value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('High Quality Images'),
                  subtitle: const Text('Load higher resolution posters'),
                  value: settings.enableHighQualityImages,
                  onChanged: (value) {
                    settings.setEnableHighQualityImages(value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Auto-load More Movies'),
                  subtitle: const Text('Automatically load more when scrolling to end'),
                  value: settings.autoLoadMoreMovies,
                  onChanged: (value) {
                    settings.setAutoLoadMoreMovies(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}