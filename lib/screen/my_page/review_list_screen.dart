import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  // 더미 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      "title": "87세김경식할아버지인생최후의끌어치기",
      "rating": 1,
      "description": "",
    },
    {
      "title": "생존입니다",
      "rating": 2,
      "description": "떡볶이가 even하게 익었습니다.",
    },
    {
      "title": "87세김경식할아버지인생최후의끌어치기",
      "rating": 3,
      "description": "",
    },
    {
      "title": "생존입니다",
      "rating": 4,
      "description": "떡볶이가 even하게 익었습니다.",
    },
    {
      "title": "87세김경식할아버지인생최후의끌어치기",
      "rating": 5,
      "description": "",
    },
    {
      "title": "생존입니다",
      "rating": 4,
      "description": "떡볶이가 even하게 익었습니다.",
    },
    {
      "title": "87세김경식할아버지인생최후의끌어치기",
      "rating": 3,
      "description": "",
    },
    {
      "title": "생존입니다",
      "rating": 4,
      "description": "떡볶이가 even하게 익었습니다.",
    },
    {
      "title": "87세김경식할아버지인생최후의끌어치기",
      "rating": 5,
      "description": "",
    },
    {
      "title": "생존입니다",
      "rating": 4,
      "description": "떡볶이가 even하게 익었습니다.",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Color(0xfff5f5f5),
          ),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 리뷰 제목
                  Text(
                    review['title'],
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
                  if (review['description'] != '')
                    SizedBox(height: 16),

                  // 리뷰 설명
                  if (review['description'] != '')
                    Text(
                      review['description'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
