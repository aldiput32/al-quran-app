import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/audio_player_bar.dart';
import 'home_screen.dart';
import 'bookmarks_screen.dart';
import 'doa_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BookmarksScreen(),
    DoaScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Persistent Floating Audio Player
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AudioPlayerBar(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primaryContainer.withOpacity(isDark ? 0.3 : 0.8),
          elevation: 0,
          onDestinationSelected: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(
                Icons.menu_book_rounded,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              label: 'Al-Qur\'an',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(
                Icons.bookmark_rounded,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              label: 'Bookmark',
            ),
            NavigationDestination(
              icon: const Icon(Icons.volunteer_activism_outlined),
              selectedIcon: Icon(
                Icons.volunteer_activism_rounded,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              label: 'Doa',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: Icon(
                Icons.settings_rounded,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}
