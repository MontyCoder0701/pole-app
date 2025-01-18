import 'package:flutter/material.dart';

import 'progress-detail.page.dart';
import 'theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final List<List<bool>> _completedTasks = [
    [true, true, false, true, false, true, false],
    List.generate(9, (_) => false),
    List.generate(9, (_) => false),
  ];

  final List<List<String>> _exampleTasks = [
    [
      '베이스볼 그립',
      '클라임',
      '폴싯',
      '팅커벨',
      '프린세스',
      '이지 보텍스',
      '핀업걸',
    ],
    [
      '다프네',
      '투클라임',
      '큐피드',
      '턴테이블',
      '앞으로 회전 스텝',
      '뒤로 회전 스텝',
      '하프 플랭크 자세',
      '무게 중심 이동 연습',
      '폴에서 두 다리 들기',
      '중급 스트레칭',
    ],
    [
      '풀 스핀',
      '폴 위에서 다리 벌리기',
      '폴과 함께 플립',
      '폴 역회전 턴',
      '한 손으로 폴 잡기 연습',
      '상체와 하체 조화 동작',
      '폴에서 몸 비틀기',
      '폴 위에서 하체 이동',
      '고급 스트레칭',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '동작 도장깨기!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '난이도 별 동작 도장깨기에 도전해보세요! 각 동작을 눌러 지금까지 내 성장기록을 살펴보세요!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 30),
              itemCount: _completedTasks.length,
              itemBuilder: (context, gridIndex) {
                final title = ['나는 폴린이!', '이제 초급!', '좀 하는 중급'][gridIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: _completedTasks[gridIndex].length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgressDetailPage(
                                  taskTitle: _exampleTasks[gridIndex][index],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      _exampleTasks[gridIndex][index],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              if (_completedTasks[gridIndex][index])
                                Center(
                                  child: Icon(
                                    Icons.verified,
                                    size: 80,
                                    color: CustomColor.primary
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
