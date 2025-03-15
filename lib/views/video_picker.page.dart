import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../theme.dart';
import 'record-create.page.dart';

class VideoPickerPage extends StatefulWidget {
  const VideoPickerPage({super.key});

  @override
  VideoPickerPageState createState() => VideoPickerPageState();
}

class VideoPickerPageState extends State<VideoPickerPage> {
  List<AssetEntity> _videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final permission = await PhotoManager.requestPermissionExtend();
    // TODO: 권한 (부분 / 거절) 관련 처리
    if (!permission.isAuth) {
      return;
    }

    final List<AssetPathEntity> videoPaths =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    if (videoPaths.isNotEmpty) {
      final List<AssetEntity> videos = await videoPaths.first.getAssetListPaged(
        page: 0,
        size: 100,
      );

      setState(() {
        _videos = videos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('새 기록을 만들어봐요 ✏️')),
      body:
          _videos.isEmpty
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
                        '가져올 수 있는 영상이 없습니다.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '설정에서 더 많은 영상을 추가해주세요.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          PhotoManager.openSetting();
                        },
                        icon: Icon(Icons.add),
                        label: Text('설정에서 영상 추가하기'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push<AssetEntity>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordCreatePage(video: video),
                        ),
                      );
                    },
                    child: FutureBuilder<Widget>(
                      future: video
                          .thumbnailDataWithSize(ThumbnailSize(200, 200))
                          .then((data) {
                            if (data != null) {
                              return Image.memory(data, fit: BoxFit.cover);
                            }
                            return Icon(Icons.broken_image);
                          }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return snapshot.data!;
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  );
                },
              ),
    );
  }
}
