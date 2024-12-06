import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/const/colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneNumberController = TextEditingController();
  final _verifyController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  bool _isPhoneNumberValid = false;
  bool _isVerifyValid = false;
  bool _isNicknameValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isValid = false;
  bool _availableVerify = false;
  String? _phoneNumberError;
  String? _verifyError;
  String? _nicknameError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "회원가입",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
      resizeToAvoidBottomInset: true,
      // 키패드로 인해 화면 크기 조정 허용
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // 화면 크기 유지
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        controller: _phoneNumberController,
                        label: "휴대폰 번호를 입력해주세요.",
                        type: 'phoneNumber',
                        hintText: "010-1234-5678",
                        errorText: _phoneNumberError,
                      ),
                      SizedBox(height: _phoneNumberError == null ? 15.0 : 5.0),
                      GestureDetector(
                        child: Text(
                          '인증번호 전송',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[400]),
                        ),
                        onTap: () async {
                          _validatePhoneNumber();
                          if (!_isPhoneNumberValid) {
                            return;
                          }

                          // final baseUrl = dotenv.env['BASE_URL'];
                          // final response = await _dio.post('$baseUrl/auth/check/phone-number');
                          //
                          // if (response.statusCode == 200) {
                          //   setState(() {
                          //     _availableVerify = true;
                          //   });
                          // }

                          setState(() {
                            _availableVerify = true;
                          });
                        },
                      ),
                      if (_availableVerify) SizedBox(height: 20.0),
                      if (_availableVerify)
                        _buildPasswordField(
                          controller: _verifyController,
                          label: "인증번호를 입력해주세요.",
                          type: 'verify',
                          errorText: _verifyError,
                        ),
                      SizedBox(height: 40),
                      _buildPasswordField(
                        controller: _nicknameController,
                        label: "닉네임을 입력해주세요.",
                        hintText: "닉네임을 입력하세요.",
                        type: 'nickname',
                        errorText: _nicknameError,
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        controller: _passwordController,
                        label: "비밀번호를 입력해주세요",
                        hintText: "비밀번호를 입력하세요.",
                        type: 'new',
                        errorText: _passwordError,
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: "확인을 위해 다시 비밀번호를 입력해주세요",
                        hintText: "비밀번호를 입력하세요.",
                        type: 'confirm',
                        errorText: _confirmPasswordError,
                      ),
                      SizedBox(height: 20), // 추가 간격
                      Spacer(), // 빈 공간 확보
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (!_isValid) {
                return;
              }

              String phoneNumber = _phoneNumberController.text;
              String nickname = _nicknameController.text;
              String password = _passwordController.text;
              bool acceptMarketing = false;

              try {
                final baseUrl = dotenv.env['BASE_URL'];
                final response = await _dio.post('$baseUrl/auth/signup', data: {
                  'nickname': nickname,
                  'password': password,
                  'phoneNumber': phoneNumber,
                  'acceptMarketing': acceptMarketing,
                });

                if (response.statusCode == 200) {
                  print('회원가입 완료');
                  Navigator.pop(context);
                }
              } catch(e) {
                print('회원가입 실패: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isValid
                  ? defaultColors['green']
                  : defaultColors['lightGreen'], // 버튼 색상
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // Border radius 설정
              ),
            ),
            child: Text(
              '회원가입',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: type == 'phoneNumber' || type == 'verify' ||
              type == 'nickname' ? false : true,
          decoration: InputDecoration(
            filled: true,
            fillColor: defaultColors['white'],
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
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
            errorText: null, // 아래 커스텀 메시지로 대체
          ),
          onChanged: (value) {
            if (type == 'phoneNumber') {
              _validatePhoneNumber();
            }

            if (type == 'nickname') {
              _validateNickname();
            }

            if ('$type' == 'new' || type == 'confirm') {
              _validatePassword();
              _validateConfirmPassword();
            }
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: TextStyle(color: defaultColors['green'], fontSize: 12),
            ),
          ),
      ],
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    RegExp phoneNumberRegex = RegExp(
      r'^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$',
    );
    return phoneNumberRegex.hasMatch(phoneNumber);
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

  void _validateNickname() {
    setState(() {
      String nickname = _nicknameController.text;

      if (validateNickname(nickname)) {
        _isNicknameValid = true;
        _nicknameError = null;
      } else {
        _isNicknameValid = false;
        _nicknameError = '닉네임은 한글, 영문, 숫자만 입력 가능합니다.';
        return;
      }

      if (nickname.length <= 10 && nickname.length >= 2) {
        _isValid = true;
        _nicknameError = null; // 오류 메시지 제거
      } else {
        _isValid = false;
        _nicknameError = '닉네임을 2~10자로 입력해주세요.';
        return;
      }
    });

    _validateForm();
  }

  bool validateNickname(String nickname) {
    RegExp nicknameRegex = RegExp(
      r'^[ㄱ-ㅎㅏ-ㅣa-zA-Z가-힣0-9]+$',
    );
    return nicknameRegex.hasMatch(nickname);
  }

  void _validatePassword() {
    setState(() {
      String password = _passwordController.text;

      if (validatePassword(password)) {
        _isPasswordValid = true;
        _passwordError = null;
      } else {
        _isPasswordValid = false;
        _passwordError = '10자 이상 영어 대문자, 소문자, 숫자, 특수문자 중 2종류를 조합해야 합니다.';
      }
    });

    _validateForm();
  }

  bool validatePassword(String password) {
    RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z]|.*[0-9]|.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{10,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  void _validateConfirmPassword() {
    setState(() {
      String confirmPassword = _confirmPasswordController.text;

      if (confirmPassword == '' && _confirmPasswordError == null) {
        return;
      }

      if (confirmPassword == _passwordController.text) {
        _isConfirmPasswordValid = true;
        _confirmPasswordError = null;
      } else {
        _isConfirmPasswordValid = false;
        _confirmPasswordError = '비밀번호가 일치하지 않습니다. 다시 입력해주세요.';
      }
    });

    _validateForm();
  }

  void _validateForm() {
    setState(() {
      // _isValid = _isPhoneNumberValid && _isNicknameValid && _isPasswordValid && _isConfirmPasswordValid && _isVerifyValid;
      _isValid = _isPhoneNumberValid && _isNicknameValid && _isPasswordValid &&
          _isConfirmPasswordValid;
    });
  }
}
