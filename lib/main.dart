import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';
import 'views/home.page.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polinii',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColor.primary),
        appBarTheme: AppBarTheme(centerTitle: false, color: Colors.transparent),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 1),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
