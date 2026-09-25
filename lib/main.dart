import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/compass/presentation/compass_screen.dart';
import 'features/lunar_calendar/presentation/lunar_calendar_screen.dart';
import 'features/lookup_webview/presentation/lookup_webview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhongThuyApp());
}

class PhongThuyApp extends StatelessWidget {
  const PhongThuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Bàn Phong Thuỷ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        primaryColor: AppColors.woodAccent,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.woodAccent,
          secondary: AppColors.woodBorder,
          surface: AppColors.surfaceCard,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    CompassScreen(),
    LunarCalendarScreen(),
    LookupWebViewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.surfaceCard,
        selectedItemColor: AppColors.woodAccent,
        unselectedItemColor: Colors.white38,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'La Bàn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Lịch Âm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Tra Cứu',
          ),
        ],
      ),
    );
  }
}
