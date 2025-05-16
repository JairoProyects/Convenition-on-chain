import 'package:flutter/material.dart';
import 'home_page.dart';
import 'create_agreement_page.dart';
import 'view_agreement_page.dart';

class MenuTopTabsPage extends StatefulWidget {
  const MenuTopTabsPage({super.key});

  @override
  State<MenuTopTabsPage> createState() => _MenuTopTabsPageState();
}

class _MenuTopTabsPageState extends State<MenuTopTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> topTabs = const [
    Tab(icon: Icon(Icons.home_rounded)),
    Tab(icon: Icon(Icons.edit_document)),
    Tab(icon: Icon(Icons.article_outlined)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: topTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Convenio On-Chain',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    tabs: topTabs,
                    isScrollable: false,
                    indicatorColor: Colors.blueAccent,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.white54,
                    labelColor: Colors.blueAccent,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  HomePage(),
                  CreateAgreementPage(),
                  ViewAgreementPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
