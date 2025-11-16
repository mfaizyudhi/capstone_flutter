import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'report_screen.dart';
import 'education_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;

  const HomeScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const MapScreen(),
      const ReportScreen(),
      const EducationScreen(),
      ProfileScreen(name: widget.name, email: widget.email),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== BACKGROUND BIRU BIASA =====
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF1565C0), // biru biasa (Blue 800)
        child: pages[_selectedIndex],
      ),

      // ===== NAVIGASI BAWAH =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),

        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue.shade700.withOpacity(0.8),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.map, "Peta", 0),
              navItem(Icons.report, "Laporan", 1),
              navItem(Icons.school, "Edukasi", 2),
              navItem(Icons.person, "Profil", 3),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ITEM NAVIGASI (ANIMASI) =====
  Widget navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isActive ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 28,
                color: isActive ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isActive ? 1 : 0,
              child: Text(
                isActive ? label : "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
