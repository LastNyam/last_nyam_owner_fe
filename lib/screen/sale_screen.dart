import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/const/numberFormat.dart';

class AppColors {
  static const Color blackColor = Color(0xFF262626);
  static const Color whiteColor = Color(0xFFFAFAFA);
  static const Color semiwhite = Color(0xFFF2F2F2);
  static const Color grayColor = Color(0xFF6B7280);
  static const Color semigray = Color(0xFFf9f9f9);
  static const Color greenColor = Color(0xFF417C4E);
  static const Color semigreen = Color(0xFFB9C6BC);
}

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key}) : super(key: key);

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  Map<String, dynamic> progressMessage = {
    'waiting': '고객님의 주문 수락을 기다리고 있어요.',
    'accepted': '고객님이 가게로 오고 있어요.',
    'success': '수령 완료',
    'failed': '미수령',
  };

  List<Map<String, dynamic>> orderItems = [
    {
      'userNickname': '닉네임1',
      'userProfile': null,
      'status': 'waiting',
      'foodName': '국내산 돼지고기',
      'number': 4,
      'price': 12900,
      'reservationDate': '2024-12-05T21:33:33',
    },
    {
      'userNickname': '닉네임2',
      'userProfile': null,
      'status': 'accepted',
      'foodName': '국내산 돼지고기',
      'number': 4,
      'price': 12900,
      'reservationDate': '2024-12-05T21:33:33',
    },
    {
      'userNickname': '닉네임3',
      'userProfile': null,
      'status': 'success',
      'foodName': '국내산 돼지고기',
      'number': 4,
      'price': 12900,
      'reservationDate': '2024-12-05T21:33:33',
    },
    {
      'userNickname': '닉네임4',
      'userProfile': null,
      'status': 'failed',
      'foodName': '국내산 돼지고기',
      'number': 4,
      'price': 12900,
      'reservationDate': '2024-12-05T21:33:33',
    },
  ];

  void removeOrder(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '냠냠 판매',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final order = orderItems[index];
          print(progressMessage[order['status']]);
          return OrderItem(
            progress: progressMessage[order['status']],
            userNickName: order['userNickname'],
            userProfile: order['userProfile'],
            status: order['status'],
            foodName: order['foodName'],
            number: order['number'],
            price: order['price'],
            reservationDate: order['reservationDate'],
            onCancel: () => removeOrder(index), // 삭제 함수 전달
          );
        },
      ),
    );
  }
}

class OrderItem extends StatefulWidget {
  final String progress;
  final String userNickName;
  final String? userProfile;
  final String status;
  final String foodName;
  final int number;
  final int price;
  final String reservationDate;
  final VoidCallback? onCancel;

  OrderItem({
    required this.progress,
    required this.userNickName,
    required this.userProfile,
    required this.foodName,
    required this.number,
    required this.price,
    required this.status,
    required this.reservationDate,
    this.onCancel,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.status; // 초기 상태 설정
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      color: AppColors.whiteColor,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              '${status == 'waiting' || status == 'accepted' ? widget.progress : '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.reservationDate))} ${widget.progress}'}',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: widget.userProfile != null
                          ? Image.network(
                        widget.userProfile!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        color: grey[300],
                        width: 50,
                        height: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userNickName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                widget.foodName,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '${widget.number}개',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.price.toThousandSeparated()}원',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (status == 'waiting')
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.whiteColor,
                                      title: Text("예약 취소"),
                                      content: Text("예약을 취소하시겠습니까?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("아니오"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget.onCancel?.call();
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColors.greenColor,
                                          ),
                                          child: Text(
                                            "예",
                                            style: TextStyle(
                                                color: AppColors.whiteColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.semiwhite,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                minimumSize: Size(0, 30),
                                textStyle: TextStyle(
                                    fontSize: 10, color: AppColors.blackColor),
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(color: AppColors.blackColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  status = 'accepted';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greenColor,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                minimumSize: Size(0, 30),
                                textStyle: TextStyle(
                                    fontSize: 10, color: AppColors.whiteColor),
                              ),
                              child: Text(
                                "수락",
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (status == 'accepted')
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomCircularTimer(remainingMinutes: 10),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// 커스텀 타이머 위젯
class CustomCircularTimer extends StatefulWidget {
  final int remainingMinutes;

  CustomCircularTimer({required this.remainingMinutes});

  @override
  _CustomCircularTimerState createState() => _CustomCircularTimerState();
}

class _CustomCircularTimerState extends State<CustomCircularTimer> {
  late int remainingMinutes;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.remainingMinutes;

    // 타이머 시작: 1분마다 감소
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (remainingMinutes > 0) {
        setState(() {
          remainingMinutes--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = remainingMinutes / widget.remainingMinutes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 10),
        Container(
          width: 55, // 타이머 크기 조정 (가로)
          height: 55, // 타이머 크기 조정 (세로)
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage, // 진행 상태
                color: AppColors.greenColor,
                backgroundColor: AppColors.grayColor.withOpacity(0.2),
                strokeWidth: 3.0, // 원의 두께
              ),
              Text(
                '${remainingMinutes}분',
                style: TextStyle(
                  fontSize: 12, // 타이머 텍스트 크기
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}