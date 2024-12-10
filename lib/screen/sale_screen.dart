import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/const/numberFormat.dart';
import 'package:last_nyam_owner/screen/loading.dart';
import 'package:provider/provider.dart';

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
    'BEFORE_ACCEPT': '고객님의 주문 수락을 기다리고 있어요.',
    'RESERVATION': '고객님이 가게로 오고 있어요.',
    'CANCEL': '취소',
    'RECEIVED': '수령 완료',
    'NOT_RECEIVED': '미수령',
  };

  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  List<dynamic> orderItems = [];
  bool _isLoading = true;

  void removeOrder(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    getSaleList();
  }

  Future<void> getSaleList() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      String? token = await _storage.read(key: 'authToken');
      final response = await _dio.get(
        '$baseUrl/reservation',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response);

      if (response.statusCode == 200) {
        setState(() {
          orderItems = response.data['data'];
          _isLoading = false;
        });
      }
    } on DioError catch (e) {
      print('냠냠판매 불러오기 실패: ${e.response?.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return !userState.isLogin
        ? Center(
            child: Text(
              '로그인 후 이용가능합니다.',
              style:
                  TextStyle(color: defaultColors['lightGreen'], fontSize: 18),
            ),
          )
        : _isLoading
            ? LoadingScreen()
            : Scaffold(
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
                      reservationId: order['reservationId'],
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
  final int reservationId;
  final String progress;
  final String userNickName;
  final String? userProfile;
  final String status;
  final String foodName;
  final int number;
  final int price;
  final String? reservationDate;
  final VoidCallback? onCancel;

  OrderItem({
    required this.reservationId,
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
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    status = widget.status; // 초기 상태 설정
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      color: AppColors.whiteColor,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              '${status == 'BEFORE_ACCEPT' || status == 'RESERVATION' || status == 'CANCEL' ? widget.progress : '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.reservationDate!))} ${widget.progress}'}',
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
                          ? Image.memory(
                              Uint8List.fromList(
                                  base64Decode(widget.userProfile!)),
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
                    if (status == 'BEFORE_ACCEPT')
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15),
                                            bottom: Radius.circular(15)),
                                      ),
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
                                          onPressed: () async {
                                            try {
                                              final baseUrl =
                                                  dotenv.env['BASE_URL'];
                                              String? token = await _storage
                                                  .read(key: 'authToken');
                                              final response = await _dio.post(
                                                '$baseUrl/reservation/${widget.reservationId}/cancel',
                                                data: {
                                                  'cancelMessage':
                                                      "예약이 취소되었습니다.",
                                                },
                                                options: Options(
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $token'
                                                  },
                                                ),
                                              );

                                              if (response.statusCode == 200) {
                                                Navigator.of(context).pop();
                                                widget.onCancel?.call();
                                              }
                                            } on DioError catch (e) {
                                              print(
                                                  '예약 취소 실패: ${e.response?.data}');
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                AppColors.greenColor,
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
                              onPressed: () async {
                                try {
                                  final baseUrl = dotenv.env['BASE_URL'];
                                  String? token =
                                      await _storage.read(key: 'authToken');
                                  final response = await _dio.post(
                                    '$baseUrl/reservation/${widget.reservationId}/ok',
                                    options: Options(
                                      headers: {
                                        'Authorization': 'Bearer $token'
                                      },
                                    ),
                                  );
                                } on DioError catch (e) {
                                  print('예약 수락 실패: ${e.response?.data}');
                                }

                                setState(() {
                                  status = 'RESERVATION';
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
                    if (status == 'RESERVATION')
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomCircularTimer(
                          reservationId: widget.reservationId,
                          remainingMinutes: 10 +
                                      calculateMinutesDifference(
                                          widget.reservationDate != null
                                              ? widget.reservationDate!
                                              : DateTime.now().toString()) <
                                  0
                              ? 0
                              : 10 +
                                  calculateMinutesDifference(
                                      widget.reservationDate != null
                                          ? widget.reservationDate!
                                          : DateTime.now().toString()),
                        ),
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

int calculateMinutesDifference(String inputTime) {
  // 입력 시간은 ISO8601 형식(예: "2024-12-10T14:00:00")이라고 가정
  DateTime parsedInputTime = DateTime.parse(inputTime);

  // 현재 시간 가져오기
  DateTime now = DateTime.now();

  // 시간 차이를 계산 (in minutes)
  Duration difference = parsedInputTime.difference(now);
  int minutesDifference = difference.inMinutes;

  print('시간: $minutesDifference');

  return minutesDifference;
}

class CustomCircularTimer extends StatefulWidget {
  final int reservationId;
  final int remainingMinutes;

  CustomCircularTimer({
    required this.reservationId,
    required this.remainingMinutes,
  });

  @override
  _CustomCircularTimerState createState() => _CustomCircularTimerState();
}

class _CustomCircularTimerState extends State<CustomCircularTimer> {
  late int remainingMinutes;
  late Timer timer;
  late bool isTimerCompleted; // 타이머 완료 상태를 관리하는 변수 추가
  final _storage = const FlutterSecureStorage();
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.remainingMinutes;
    isTimerCompleted = remainingMinutes == 0;

    // 타이머 시작: 1분마다 감소
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (remainingMinutes > 0) {
        setState(() {
          remainingMinutes--;
        });
      } else {
        setState(() {
          isTimerCompleted = true; // 타이머가 완료되면 상태 업데이트
        });
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
    double percentage = widget.remainingMinutes != 0
        ? remainingMinutes / widget.remainingMinutes
        : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isTimerCompleted) // 타이머가 완료되지 않았을 때 CircularProgressIndicator 표시
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
          )
        else
          Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    // 버튼 클릭 시 동작 정의
                    print("타이머 완료 후 버튼 클릭!");
                    final baseUrl = dotenv.env['BASE_URL'];
                    String? token = await _storage.read(key: 'authToken');
                    final response = await _dio.patch(
                      '$baseUrl/reservation/${widget.reservationId}/status',
                      data: {'status': 'NOT_RECEIVED'},
                      options: Options(
                        headers: {'Authorization': 'Bearer $token'},
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['white'],
                  ),
                  child: Text(
                    "미수령",
                    style:
                        TextStyle(color: defaultColors['black'], fontSize: 18),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    final baseUrl = dotenv.env['BASE_URL'];
                    String? token = await _storage.read(key: 'authToken');
                    final response = await _dio.patch(
                      '$baseUrl/reservation/${widget.reservationId}/status',
                      data: {'status': 'RECEIVED'},
                      options: Options(
                        headers: {'Authorization': 'Bearer $token'},
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                  ),
                  child: Text(
                    " 수령 ",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 18),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
