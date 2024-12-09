import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/screen/loading.dart';
import 'package:provider/provider.dart';

import '../../component/provider/user_state.dart';

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late final reviewList;
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  bool _isLoading = true;

  // 더미 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      "userNickname": "87세김경식할아버지인생최후의끌어치기",
      "rating": 1,
      "content": "",
    },
    {
      "userNickname": "생존입니다",
      "rating": 2,
      "content": "떡볶이가 even하게 익었습니다.",
    },
    {
      "userNickname": "87세김경식할아버지인생최후의끌어치기",
      "rating": 3,
      "content": "",
    },
    {
      "userNickname": "생존입니다",
      "rating": 4,
      "content": "떡볶이가 even하게 익었습니다.",
    },
    {
      "userNickname": "87세김경식할아버지인생최후의끌어치기",
      "rating": 5,
      "content": "",
    },
    {
      "userNickname": "생존입니다",
      "rating": 4,
      "content": "떡볶이가 even하게 익었습니다.",
    },
    {
      "userNickname": "87세김경식할아버지인생최후의끌어치기",
      "rating": 3,
      "content": "",
    },
    {
      "userNickname": "생존입니다",
      "rating": 4,
      "content": "떡볶이가 even하게 익었습니다.",
    },
    {
      "userNickname": "87세김경식할아버지인생최후의끌어치기",
      "rating": 5,
      "content": "",
    },
    {
      "userNickname": "생존입니다",
      "rating": 4,
      "content": "떡볶이가 even하게 익었습니다.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getReviewList();
  }

  void _getReviewList() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      String? token = await _storage.read(key: 'authToken');
      final response = await _dio.get(
        '$baseUrl/review',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        reviewList = response.data['data'];
      }
    } on DioError catch (e) {
      print('리뷰 리스트 조회 실패: ${e.response?.data}');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "받은 냠냠 평가",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: !userState.isLogin
          ? Center(
              child: Text(
                '로그인 후 이용가능합니다.',
                style:
                    TextStyle(color: defaultColors['lightGreen'], fontSize: 18),
              ),
            )
          : _isLoading
              ? LoadingScreen()
              : Container(
                  color: Colors.white,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    itemCount: reviewList.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Color(0xfff5f5f5),
                    ),
                    itemBuilder: (context, index) {
                      final review = reviewList[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 리뷰 제목
                            Text(
                              review['userNickname'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),

                            // 평점 (별표 표시)
                            Row(
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Icon(
                                    Icons.star,
                                    color: i <= review['rating']
                                        ? defaultColors['green']
                                        : defaultColors['white'],
                                    size: 15,
                                  ),
                              ],
                            ),
                            if (review['content'] != '') SizedBox(height: 16),

                            // 리뷰 설명
                            if (review['content'] != '')
                              Text(
                                review['content'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
