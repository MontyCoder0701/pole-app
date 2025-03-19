import 'package:flutter/material.dart';

import 'records.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;

  final List<Widget> _pages = [
    const RecordsPage(),
    // TODO: 이후 업데이트에 추가
    // const ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      // TODO: 이후 업데이트에 추가
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.photo_camera_back),
      //       label: '내 폴기록',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.flag_outlined),
      //       label: '내 성장기록',
      //     ),
      //   ],
      // ),
    );
  }
}
