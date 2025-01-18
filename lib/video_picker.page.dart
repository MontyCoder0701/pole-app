import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
      final List<AssetEntity> videos =
          await videoPaths.first.getAssetListPaged(page: 0, size: 100);

      setState(() {
        _videos = videos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 기록을 만들어봐요 ✏️'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, video);
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
