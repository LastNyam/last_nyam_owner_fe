import 'package:last_nyam_owner/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:last_nyam_owner/const/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: "assets/env/.env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 방향 고정
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserState()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NanumBarunGothic',
          scaffoldBackgroundColor: defaultColors['white'],

          textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'NanumBarunGothic',
            bodyColor: defaultColors['black'], // 텍스트 색상
            displayColor: defaultColors['black']  // 헤더 텍스트 색상
          ),

          appBarTheme: AppBarTheme(
            backgroundColor: defaultColors['pureWhite'], // AppBar 배경색
            titleTextStyle: TextStyle(
              fontFamily: 'nanumBarunGothic',
              color: defaultColors['black'],
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: defaultColors['black']
              )
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: defaultColors['black'], // 텍스트 색상
              backgroundColor: defaultColors['pureWhite'], // 버튼 배경색
              elevation: 0, // 그림자 제거
              textStyle: TextStyle(
                fontFamily: 'nanumBarunGothic',
                fontSize: 16,
              ),
            ),
          ),
          dialogBackgroundColor: defaultColors['pureWhite']
      ),
      home: RootScreen(),
    );
  }
}