import 'package:flutter/material.dart';
import 'home/menu_top_tab_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MenuTopTabsPage(), // mantiene el nombre correcto
    );
  }
}
