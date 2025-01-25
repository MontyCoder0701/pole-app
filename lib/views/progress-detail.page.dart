import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../theme.dart';
import '../utils/date.util.dart';

class ProgressDetailPage extends StatefulWidget {
  final String taskTitle;

  const ProgressDetailPage({super.key, required this.taskTitle});

  @override
  State<ProgressDetailPage> createState() => _ProgressDetailPageState();
}

class _ProgressDetailPageState extends State<ProgressDetailPage> {
  late Future<List<AssetEntity>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchVideos();
  }

  Future<List<AssetEntity>> _fetchVideos() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    // TODO: 앱 권한 관련 확인
    if (result.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false,
            ),
          ],
        ),
      );
      if (albums.isNotEmpty) {
        final List<AssetEntity> videos =
            await albums.first.getAssetListPaged(page: 0, size: 20);
        return videos;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${widget.taskTitle} 기억들',
          style: TextStyle(
            color: CustomColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text: '2024년 8월 15일',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: '에 처음 했어요!',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text: '총 ',
                        ),
                        TextSpan(
                          text: '8번',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: ' 도전했어요!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<AssetEntity>>(
            future: _videosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('영상 연결 에러가 발생했어요.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('관련 기억이 없네요.'));
              } else {
                final List<AssetEntity> videos = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return GestureDetector(
                      onTap: () async {
                        final file = await video.file;
                        if (file != null) {
                          debugPrint('Video id: ${video.id}');
                          debugPrint('Video Path: ${file.path}');
                        }
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                formatDate(video.createDateTime),
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 300,
                                child: FutureBuilder<Widget>(
                                  future: video
                                      .thumbnailDataWithSize(
                                    ThumbnailSize(300, 500),
                                  )
                                      .then((data) {
                                    if (data != null) {
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
                              SizedBox(height: 20),
                              Text(
                                '조금만 더 올라가서 다리 걸어야겠다. 아무래도 높이 안걸다보니까 프린세스가 예쁘게 완성되지 않았다.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
