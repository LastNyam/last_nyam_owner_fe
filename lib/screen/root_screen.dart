import 'package:flutter/material.dart';
import 'package:last_nyam_owner/screen/home_screen.dart';
import 'package:last_nyam_owner/screen/sale_screen.dart';
import 'package:last_nyam_owner/screen/my_page_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin{
  // 사용할 TabController 선언
  TabController? controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller!.addListener(tabListener);
  }

  // listener로 사용할 함수
  tabListener() {
    setState(() {});
  }

  // listener에 등록한 함수 등록 취소
  @override
  dispose(){
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 탭 화면을 보여줄 위젯
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: renderChildren(),
      ),

      // 아래 탭 네비게이션을 구현하는 매개변수
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren(){
    return [
      HomeScreen(),
      SaleScreen(),
      MyPageScreen(),
    ];
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: controller!.index,
      onTap: (int index) {  // ➎ 탭이 선택될 때마다 실행되는 함수
        setState(() {
          controller!.animateTo(index);
        });
      },
      selectedItemColor: Color(0xFF417C4E),  // 선택된 탭의 색상
      unselectedItemColor: Color(0xFFB9C6BC),  // 선택되지 않은 탭의 색상
      selectedLabelStyle: TextStyle(
        height: 2.0,
      ),
      unselectedLabelStyle: TextStyle(
        height: 2.0,
      ),
      items: [
        BottomNavigationBarItem(  // ➊ 하단 탭바의 각 버튼을 구현
          icon: Icon(
            Icons.home_filled,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.room_service_rounded,
          ),
          label: '냠냠판매',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dining_outlined,
          ),
          label: '마이냠',
        ),
      ],
    );
  }
}