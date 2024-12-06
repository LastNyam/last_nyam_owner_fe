import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:last_nyam_owner/screen/my_page/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/const/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  bool _isPhoneNumberValid = false;
  bool _isPasswordValid = false;
  bool _isValid = false;
  String? _phoneNumberError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "로그인",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField(
                controller: _phoneNumberController,
                label: "휴대폰 번호를 입력해주세요",
                type: 'phoneNumber',
                hintText: "010-1234-5678",
                errorText: _phoneNumberError,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _passwordController,
                label: "비밀번호를 입력해주세요",
                hintText: "비밀번호를 입력하세요.",
                type: 'password',
                errorText: _passwordError,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(fontSize: 14.0, color: grey[400]),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                          // builder: (context) => ProfileEditScreen(),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        '회원가입',
                        style: TextStyle(fontSize: 14.0, color: grey[400]),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid ? () => _login(userState) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValid
                        ? defaultColors['green']
                        : defaultColors['lightGreen'],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String type,
    String? hintText,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: type == 'password' ? true : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: defaultColors['white'],
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            if (type == 'phoneNumber') {
              _validatePhoneNumber();
            }
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: TextStyle(color: defaultColors['green'], fontSize: 14),
            ),
          ),
      ],
    );
  }

  Future<void> _login(UserState userState) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {
          'phoneNumber': _phoneNumberController.text,
          'password': _passwordController.text,
        },
      );

      print(response.data['data']);

      if (response.statusCode == 200 &&
          response.data['data']['token'] != null) {
        String token = response.data['data']['token'];

        // Save token in secure storage
        await _storage.write(key: 'authToken', value: token);

        final userResponse = await _dio.get('$baseUrl/auth/my-info',
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        if (userResponse.statusCode == 200) {
          final userState = Provider.of<UserState>(context, listen: false);
          userState.updateUserName(userResponse.data['data']['nickname']);
          userState.updatePhoneNumber(userResponse.data['data']['phoneNumber']);
          userState.updateStoreName(userResponse.data['data']['storeName']);
          if (userResponse.data['data']['profileImage'] != null) {
            Uint8List? profileImage = Uint8List.fromList(
                base64Decode(userResponse.data['data']['profileImage']));
            userState.updateProfileImage(profileImage);
          }
          userState.updateMannerTemperature(userResponse.data['data']['mannerTemperature']);
          userState.updateIsLogin(true);
        } else {
          await _storage.delete(key: 'authToken');
        }

        // Navigate to main screen
        Navigator.pop(context);
      } else {
        throw Exception('로그인 실패');
      }
    } catch (e) {
      print('로그인 실패: ${e}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패. 다시 시도해주세요.')),
      );
    }
  }

  void _validatePhoneNumber() {
    setState(() {
      String phoneNumber = _phoneNumberController.text;

      if (validatePhoneNumber(phoneNumber)) {
        _isPhoneNumberValid = true;
        _phoneNumberError = null;
      } else {
        _isPhoneNumberValid = false;
        _phoneNumberError = '유효한 휴대폰 번호가 아닙니다.';
      }
    });

    _validateForm();
  }

  bool validatePhoneNumber(String phoneNumber) {
    RegExp phoneNumberRegex = RegExp(
      r'^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$',
    );
    return phoneNumberRegex.hasMatch(phoneNumber);
  }

  void _validatePassword() {
    setState(() {
      String password = _passwordController.text;

      if (password == 'dswvgw1234') {
        _isPasswordValid = true;
        _passwordError = null;
      } else {
        _isPasswordValid = false;
        _passwordError = '비밀번호가 일치하지 않습니다.';
      }
    });

    _validateForm();
  }

  void _validateForm() {
    setState(() {
      _isValid = _isPhoneNumberValid;
    });
  }
}
