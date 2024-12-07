import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';

class StoreManageScreen extends StatefulWidget {
  @override
  _StoreManageScreenState createState() => _StoreManageScreenState();
}

class _StoreManageScreenState extends State<StoreManageScreen> {
  bool isStoreOpen = true; // 가게 영업 상태 (On/Off)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '가게 관리',
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
            // 뒤로가기 버튼 액션
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 제목과 스위치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '가게 영업 상태',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8, // Switch 크기 조절 (0.8배로 줄임)
                    child: Switch(
                      value: isStoreOpen,
                      onChanged: (value) {
                        setState(() {
                          isStoreOpen = value;
                        });
                      },
                      activeColor: Colors.white, // 공(thumb)의 색상 (활성화 상태)
                      inactiveThumbColor: Colors.white, // 공(thumb)의 색상 (비활성화 상태)
                      activeTrackColor: defaultColors['green'], // 배경 트랙 색상 (활성화 상태)
                      inactiveTrackColor: defaultColors['lightGreen'], // 배경 트랙 색상 (비활성화 상태)
                      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.transparent; // 외곽선 색상 (활성 상태)
                        }
                        return Colors.transparent; // 외곽선 색상 (비활성 상태)
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // 간격 추가

              // 설명 텍스트
              Text(
                '가게 영업 상태를 활성화하면 사용자 지도 앱에서 가게를 찾을 수 있으며 등록한 상품도 노출됩니다. '
                '영업 상태를 비활성화하면 가게와 연관된 모든 정보를 확인할 수 없게 됩니다. '
                '기존에 광고 노출이 되고 있었더라면 광고 또한 내려가게 됩니다.\n\n'
                '부득이하게 잠시 가게를 닫아야 하는 경우, 가게 영업 시간 조정을 권해드립니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: defaultColors['green'],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
