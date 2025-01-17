import 'package:flutter/material.dart';

import 'theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final List<List<bool>> _completedTasks = [
    List.generate(9, (_) => false),
    List.generate(9, (_) => false),
    List.generate(9, (_) => false),
  ];

  final List<List<String>> _exampleTasks = [
    [
      '초급 스텝 연습',
      '기본 턴 연습',
      '크로스 홀드',
      '폴 잡고 무게 옮기기',
      '기본 플랭크 자세',
      '폴에서 다리 펴기 연습',
      '한쪽 다리 들기 연습',
      '폴과 함께 걷기',
      '기본 스트레칭',
    ],
    [
      '스핀 턴',
      '폴 올라가기 연습',
      '폴에서 밸런스 잡기',
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
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 30),
          itemCount: _completedTasks.length,
          itemBuilder: (context, gridIndex) {
            final title = ['초급', '중급', '고급'][gridIndex];
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _completedTasks[gridIndex].length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _completedTasks[gridIndex][index] =
                              !_completedTasks[gridIndex][index];
                        });
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
                                color:
                                    CustomColor.primary.withValues(alpha: 0.5),
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
      ),
    );
  }
}
