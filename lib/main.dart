import 'package:last_nyam_owner/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

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
        fontFamily: 'nanumBarunGothic',
        scaffoldBackgroundColor: defaultColors['white'],
      ),
      home: RootScreen(),
    );
  }
}
