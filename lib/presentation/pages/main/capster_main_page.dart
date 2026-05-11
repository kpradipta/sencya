import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../home/capster_home_page.dart';
import '../clients/client_directory_page.dart';
import '../earnings/earnings_analytics_page.dart';
import '../profile/profile_page.dart';
// Note: Availability and Timer are usually sub-pages or triggered from actions

class CapsterMainPage extends StatefulWidget {
  const CapsterMainPage({super.key});

  @override
  State<CapsterMainPage> createState() => _CapsterMainPageState();
}

class _CapsterMainPageState extends State<CapsterMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CapsterHomePage(),
    const ClientDirectoryPage(),
    const EarningsAnalyticsPage(), // For Insights/Earnings
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.95),
          border: const Border(
            top: BorderSide(color: AppColors.borderDark, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: Colors.white24,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, size: 24),
              activeIcon: Icon(Icons.calendar_today, size: 24),
              label: 'SCHEDULE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group, size: 24),
              activeIcon: Icon(Icons.group, size: 24),
              label: 'CLIENTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics, size: 24),
              activeIcon: Icon(Icons.analytics, size: 24),
              label: 'EARNINGS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
