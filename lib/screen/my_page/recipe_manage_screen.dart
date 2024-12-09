import 'package:flutter/material.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:provider/provider.dart';

class RecipeManageScreen extends StatefulWidget {
  @override
  _RecipeManageScreenState createState() => _RecipeManageScreenState();
}

class _RecipeManageScreenState extends State<RecipeManageScreen> {
  // 더미 데이터
  List<Map<String, dynamic>> recipes = [
    {
      "title": "말랑쫄깃 밀떡",
      "description":
          "살짝 전자렌지에 돌려 꿀에 찍으면 말그대로 꿀맛입니다!! 떡볶이 해드셔도 되고 매콤달콤한 소스를 발라 떡꼬치 만들어드셔도 됩니당",
      "image": null, // 이미지 없는 경우
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
    {
      "title": "쿨피스",
      "description": "살얼음 동동 뜨도록 냉동실에 얼려놓은 쿨피스로 화채 만들기, 강추드립니다!! 레시피가 어쩌고저쩌고",
      "image": "assets/image/coolpis.png", // 이미지 URL
    },
  ];

  // 레시피 삭제 확인 다이얼로그
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40.0),
              Text(
                "레시피를 삭제하시겠습니까?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                "취소",
                style: TextStyle(fontSize: 14, color: defaultColors['black']),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColors['green'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                setState(() {
                  recipes.removeAt(index); // 레시피 삭제
                });
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                "삭제",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "레시피 관리",
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
                style: TextStyle(
                  color: defaultColors['lightGreen'],
                  fontSize: 18,
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: recipes.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Row(
                            children: [
                              Text(
                                recipe["title"],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // 레시피 상세 화면 이동 처리
                          },
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: ElevatedButton(
                            onPressed: () => _showDeleteDialog(index),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8), // 패딩 설정
                              backgroundColor: defaultColors['white'],
                            ),
                            child: Text(
                              "삭제",
                              style: TextStyle(
                                  color: defaultColors['black'], fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          recipe["description"],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        if (recipe["image"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.asset(
                              recipe["image"],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
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
