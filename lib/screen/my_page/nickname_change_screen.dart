import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';

class NicknameChangeScreen extends StatefulWidget {
  final String currentNickname; // 현재 닉네임을 전달받는 필드

  const NicknameChangeScreen({Key? key, required this.currentNickname})
      : super(key: key);

  @override
  _NicknameChangeScreenState createState() => _NicknameChangeScreenState();
}

class _NicknameChangeScreenState extends State<NicknameChangeScreen> {
  late TextEditingController _nicknameController;
  String? _errorMessage;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    // 현재 닉네임을 기본값으로 설정
    _nicknameController = TextEditingController(text: widget.currentNickname);
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final _dio = Dio();
    final _storage = const FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '상호명',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '새로운 상호명을 입력해주세요',
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  filled: true,
                  // 배경색 활성화
                  fillColor: defaultColors['white'],
                  hintText: '상호명을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isValid ? Colors.transparent : Color(0xff417c4e),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isValid ? Colors.transparent : Color(0xff417c4e),
                      width: 2.0,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                onChanged: (value) {
                  _validateInput();
                },
              ),
              if (!_isValid) ...[
                SizedBox(height: 8.0),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: defaultColors['green'],
                    fontSize: 14,
                  ),
                ),
              ],
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String newNickname = _nicknameController.text;
                    if (newNickname.isNotEmpty && _isValid) {
                      try {
                        final baseUrl = dotenv.env['BASE_URL'];
                        String? token = await _storage.read(key: 'authToken');
                        final response = await _dio.patch(
                          '$baseUrl/store/name',
                          data: {'storeName': newNickname},
                          options: Options(
                            headers: {'Authorization': 'Bearer $token'},
                          ),
                        );

                        if (response.statusCode == 200) {
                          userState.updateUserName(newNickname);
                          print('상호명 변경 완료: $newNickname');
                          Navigator.pop(context); // 변경 후 이전 화면으로 이동
                        }
                      } catch (e) {
                        print('상호명 변경 실패: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValid
                        ? defaultColors['green']
                        : defaultColors['lightGreen'], // 버튼 색상
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0), // Border radius 설정
                    ),
                  ),
                  child: Text(
                    '변경 완료',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    setState(() {
      String nickname = _nicknameController.text;

      if (nickname.length >= 2) {
        _isValid = true;
        _errorMessage = null; // 오류 메시지 제거
      } else {
        _isValid = false;
        _errorMessage = '2글자 이상 입력 가능합니다.';
        return;
      }
    });
  }
}
