import 'package:flutter/material.dart';
import 'home_page.dart';
import '../agreements/presentation/create_agreement_page.dart';
import '../agreements/presentation/view_agreement_page.dart';
import '../agreements/presentation/profile/profile_page.dart';
import '../../shared/theme/app_colors.dart';

class MenuTopTabsPage extends StatefulWidget {
  const MenuTopTabsPage({super.key});

  @override
  State<MenuTopTabsPage> createState() => _MenuTopTabsPageState();
}

class _MenuTopTabsPageState extends State<MenuTopTabsPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    CreateAgreementPage(),
    ViewAgreementPage(),
    ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_document),
      label: 'Crear',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      label: 'Ver',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Perfil',
    ),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundMain,
        ),
        child: SafeArea(child: _screens[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        backgroundColor: AppColors.panelBackground,
        selectedItemColor: AppColors.accentBlue,      // ✅ Azul claro para item activo
        unselectedItemColor: AppColors.textSecondary,  // ✅ Gris para item inactivo
        type: BottomNavigationBarType.fixed,
        items: _bottomNavItems,
      ),
    );
  }
}
