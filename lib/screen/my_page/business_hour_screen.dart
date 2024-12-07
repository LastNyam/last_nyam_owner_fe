import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusinessHoursScreen(),
    );
  }
}

class BusinessHoursScreen extends StatefulWidget {
  @override
  _BusinessHoursScreenState createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  // 요일별 데이터
  final List<Map<String, dynamic>> businessHours = [
    {'day': '월요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': []},
    {'day': '화요일', 'openTime': '', 'closeTime': '', 'isClosed': true, 'breakTimes': []},
    {'day': '수요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': []},
    {'day': '목요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': []},
    {'day': '금요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': []},
    {'day': '토요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': []},
    {'day': '일요일', 'openTime': '09:00', 'closeTime': '22:00', 'isClosed': false, 'breakTimes': ['15:00 ~ 16:00']},
  ];

  void _showEditDialog(int index) {
    final currentDay = businessHours[index];
    final TextEditingController openTimeController =
    TextEditingController(text: currentDay['openTime']);
    final TextEditingController closeTimeController =
    TextEditingController(text: currentDay['closeTime']);
    final List<String> breakTimes = List<String>.from(currentDay['breakTimes']);
    bool isClosed = currentDay['isClosed'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${currentDay['day']} 설정'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('영업일'),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: isClosed,
                            onChanged: (value) {
                              setState(() {
                                isClosed = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('휴무일'),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: isClosed,
                            onChanged: (value) {
                              setState(() {
                                isClosed = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isClosed)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: openTimeController,
                                decoration: const InputDecoration(
                                  labelText: '영업 시작 시간',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: closeTimeController,
                                decoration: const InputDecoration(
                                  labelText: '영업 종료 시간',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('휴식 시간'),
                        ...breakTimes.map((time) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(time),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    breakTimes.remove(time);
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              breakTimes.add('새 휴식 시간'); // 기본 값 추가
                            });
                          },
                          child: const Text('휴식 시간 추가'),
                        ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      businessHours[index] = {
                        'day': currentDay['day'],
                        'openTime': isClosed ? '' : openTimeController.text,
                        'closeTime': isClosed ? '' : closeTimeController.text,
                        'isClosed': isClosed,
                        'breakTimes': breakTimes,
                      };
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('수정'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영업 시간 변경'),
      ),
      body: ListView.builder(
        itemCount: businessHours.length,
        itemBuilder: (context, index) {
          final dayData = businessHours[index];
          return ListTile(
            title: Text(dayData['day']),
            subtitle: Text(dayData['isClosed']
                ? '휴무'
                : '${dayData['openTime']} ~ ${dayData['closeTime']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showEditDialog(index),
          );
        },
      ),
    );
  }
}
