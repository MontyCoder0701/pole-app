import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'record-detail.page.dart';
import 'settings.page.dart';
import 'theme.dart';
import 'utils/date.util.dart';
import 'video_picker.page.dart';
import 'widgets/chip.widget.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  // TODO: Record Entity 추가 (video id, video date, tags, memo)
  final List<AssetEntity> _videos = [];
  final List<String> _tags = ['#꼬리치기', '#아프로디테', '#투클라임'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Polinii:)',
          style: TextStyle(color: CustomColor.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _videos.isEmpty
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).canvasColor,
                    CustomColor.primary.withValues(alpha: 0.5),
                    Theme.of(context).canvasColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: CustomColor.primary.withValues(alpha: 0.7),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '새 기록을 추가해보세요!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '동영상을 추가하여 기록을 시작하세요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedVideo = await Navigator.push<AssetEntity>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPickerPage(),
                          ),
                        );

                        if (selectedVideo != null) {
                          setState(() {
                            _videos.add(selectedVideo);
                          });
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text('새 기록 추가하기'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(10),
              children: [
                SearchBar(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 15),
                  ),
                  elevation: WidgetStatePropertyAll(1),
                  trailing: [Icon(Icons.search)],
                  hintText: '동작을 검색해보세요...',
                ),
                SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordDetailPage(
                              video: video,
                              tags: _tags,
                            ),
                          ),
                        );
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
                                formatDate(video.createDateTime),
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: 180,
                                child: FutureBuilder<Widget>(
                                  future: video
                                      .thumbnailDataWithSize(
                                    ThumbnailSize(300, 500),
                                  )
                                      .then((data) {
                                    if (data != null) {
                                      // TODO: 영상 삭제된 경우 처리
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          data,
                                          fit: BoxFit.cover,
                                        ),
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
                                  CustomChip(label: '#꼬리치기'),
                                  CustomChip(label: '#아프로디테'),
                                  CustomChip(label: '#투클라임'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: Visibility(
        visible: _videos.isNotEmpty,
        child: FloatingActionButton(
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
          heroTag: 'Record',
          child: const Icon(Icons.file_upload_outlined),
        ),
      ),
    );
  }
}
