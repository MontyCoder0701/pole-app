import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../models/poling-record.model.dart';
import '../utils/date.util.dart';
import '../widgets/chip.widget.dart';

class RecordDetailPage extends StatefulWidget {
  final PolingRecord record;

  const RecordDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // TODO: 영상 존재유무 / 권한 등 확인
    final AssetEntity? video = await AssetEntity.fromId(widget.record.videoId);
    final file = await video?.file;
    if (file != null) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _startHideTimer();
        });
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          formatDate(widget.record.videoDate),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        actions: [
          // TODO: 영상 수정 범위 / 삭제 가능 여부 추가
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.record.tags.map((tag) {
              return CustomChip(label: tag);
            }).toList(),
          ),
          const SizedBox(height: 12),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.record.memo),
            ),
          ),
          const SizedBox(height: 10),
          // TODO: 영상 없는 경우 처리
          if (_controller == null || !_controller!.value.isInitialized) ...{
            const Center(child: CircularProgressIndicator()),
          } else ...{
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                  if (_showControls) {
                    _startHideTimer();
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                    if (_showControls) ...{
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: VideoProgressIndicator(
                                  _controller!,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: Theme.of(context).primaryColor,
                                    bufferedColor: Colors.grey,
                                    backgroundColor: Colors.black26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                  _startHideTimer();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),
          },
        ],
      ),
    );
  }
}
