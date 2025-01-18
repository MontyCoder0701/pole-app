import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'video_picker.page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final List<AssetEntity> _videos = [];

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _videos.isEmpty
            ? Center(
                child: Text('새 기록을 추가해보세요!'),
              )
            : ListView(
                children: [
                  SearchBar(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 15),
                    ),
                    elevation: WidgetStatePropertyAll(1),
                    leading: Icon(Icons.search),
                    hintText: '동작을 검색해보세요...',
                  ),
                  SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return GestureDetector(
                        onTap: () async {
                          final file = await video.file;
                          if (file != null) {
                            debugPrint('Video id: ${video.id}');
                            debugPrint('Video Path: ${file.path}');
                          }
                        },
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 15,
                              // TODO: Tablet / iPhone SE 확인
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _formatDate(video.createDateTime),
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 180,
                                  child: FutureBuilder<Widget>(
                                    future: video
                                        .thumbnailDataWithSize(
                                            ThumbnailSize(300, 500))
                                        .then((data) {
                                      if (data != null) {
                                        // TODO: 영상 삭제된 경우 처리
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.memory(data,
                                              fit: BoxFit.cover),
                                        );
                                      }
                                      return const Icon(Icons.broken_image);
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data != null) {
                                        return snapshot.data!;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                                Wrap(
                                  spacing: 7,
                                  runSpacing: 7,
                                  children: [
                                    // TODO:Overflow 처리
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      labelPadding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      label: Text(
                                        '#꼬리치기',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      labelPadding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      label: Text(
                                        '#아프로디테',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      labelPadding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      label: Text(
                                        '#투클라임',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () async {
          final selectedVideo = await Navigator.push<AssetEntity>(
            context,
            MaterialPageRoute(builder: (context) => VideoPickerPage()),
          );

          if (selectedVideo != null) {
            setState(() {
              _videos.add(selectedVideo);
            });
          }
        },
        child: const Icon(Icons.file_upload_outlined),
      ),
    );
  }
}
