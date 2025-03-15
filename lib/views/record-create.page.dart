import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../models/poling-record.model.dart';
import '../providers/poling-record.provider.dart';
import '../theme.dart';
import '../utils/date.util.dart';
import '../widgets/chip.widget.dart';
import 'home.page.dart';

class RecordCreatePage extends ConsumerStatefulWidget {
  final AssetEntity video;

  const RecordCreatePage({super.key, required this.video});

  @override
  ConsumerState<RecordCreatePage> createState() => _RecordCreatePageState();
}

class _RecordCreatePageState extends ConsumerState<RecordCreatePage> {
  final List<String> _tags = [];
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideTimer;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _newTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final file = await widget.video.file;
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

  void _addTag(String tag) {
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
      });
      _newTagController.clear();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    _textEditingController.dispose();
    _newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '새 기록 만들기',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: 확인 모달 추가
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.close),
          ),
          IconButton(
            onPressed: () {
              final newRecord = PolingRecord(
                videoId: widget.video.id,
                videoDate: widget.video.createDateTime,
                tags: _tags,
                memo: _textEditingController.text,
              );

              ref.read(polingRecordProvider).add(newRecord);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.check),
            color: CustomColor.primary,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Text(formatDate(widget.video.createDateTime)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _tags.map((tag) {
                  return CustomChip(label: tag);
                }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newTagController,
                  decoration: InputDecoration(
                    hintText: '동작 태그를 추가해주세요...',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: CustomColor.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: CustomColor.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () => _addTag(_newTagController.text),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '이번 폴링은 어땠나요...?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                          color: Colors.black.withAlpha(127),
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
