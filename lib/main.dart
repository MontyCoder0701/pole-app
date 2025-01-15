import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x00b43e69)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Polini'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.70,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('2025.01.11'),
                      SizedBox(
                        height: 130,
                        child: Container(color: Colors.white),
                      ),
                      // 태그 개수, 길이 overflow 처리
                      Wrap(
                        spacing: 7,
                        runSpacing: 0,
                        children: [
                          Chip(
                            visualDensity: VisualDensity.compact,
                            labelPadding: EdgeInsets.zero,
                            label: Text(
                              '#꼬리치기',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Chip(
                            visualDensity: VisualDensity.compact,
                            labelPadding: EdgeInsets.zero,
                            label: Text(
                              '#꼬리치기',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Chip(
                            visualDensity: VisualDensity.compact,
                            labelPadding: EdgeInsets.zero,
                            label: Text(
                              '#꼬리치기',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_back),
            label: 'My Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            label: 'My Progress',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
