import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/poling-record.model.dart';
import '../providers/poling-record.provider.dart';
import '../theme.dart';
import '../utils/date.util.dart';
import '../widgets/chip.widget.dart';
import 'settings.page.dart';
import 'video_picker.page.dart';

class RecordsPage extends ConsumerStatefulWidget {
  const RecordsPage({super.key});

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage> {
  late final List<PolingRecord> _records = ref.watch(polingRecordProvider);

  Future<Widget> _getVideoThumbnail(String videoId) async {
    final AssetEntity? video = await AssetEntity.fromId(videoId);
    if (video != null) {
      final thumbnailData = await video.thumbnailDataWithSize(
        ThumbnailSize(300, 500),
      );
      if (thumbnailData != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            thumbnailData,
            fit: BoxFit.cover,
          ),
        );
      }
    }
    return const Icon(Icons.broken_image);
  }

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
      body: _records.isEmpty
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VideoPickerPage(),
                          ),
                        );
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
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final PolingRecord record = _records[index];
                    return GestureDetector(
                      onTap: () async {
                        // TODO: 상세 페이지 이동
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => RecordDetailPage(
                        //       videoId: record.videoId,
                        //       tags: record.tags,
                        //     ),
                        //   ),
                        // );
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
                                formatDate(record.videoDate),
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: 180,
                                child: FutureBuilder<Widget>(
                                  future: _getVideoThumbnail(record.videoId),
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
                                children: record.tags
                                    .map((tag) => CustomChip(label: tag))
                                    .toList(),
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
        visible: _records.isNotEmpty,
        child: FloatingActionButton(
          elevation: 2,
          onPressed: () {
            Navigator.push<AssetEntity>(
              context,
              MaterialPageRoute(builder: (context) => VideoPickerPage()),
            );
          },
          heroTag: 'Record',
          child: const Icon(Icons.file_upload_outlined),
        ),
      ),
    );
  }
}
