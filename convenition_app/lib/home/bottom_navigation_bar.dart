import 'package:flutter/material.dart';
import 'home_page.dart';
import '../convenion/presentation/agreement/create_agreement_page.dart';
import '../convenion/presentation/profile/profile_page.dart';
import '../../shared/theme/app_colors.dart';

class MenuTopTabsPage extends StatefulWidget {
  final int userId;

  const MenuTopTabsPage({super.key, required this.userId});

  @override
  State<MenuTopTabsPage> createState() => _MenuTopTabsPageState();
}

class _MenuTopTabsPageState extends State<MenuTopTabsPage> {
  late final List<Widget> _screens;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomePage(),
      const CreateAgreementPage(),
      ProfilePage(userId: widget.userId),
    ];
  }

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
    BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: 'Crear'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundMain),
        child: SafeArea(child: _screens[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        backgroundColor: colors.panelBackground,
        selectedItemColor: colors.accentBlue,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: _bottomNavItems,
      ),
    );
  }
}
