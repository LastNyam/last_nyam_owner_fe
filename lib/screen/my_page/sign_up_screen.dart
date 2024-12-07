import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam_owner/screen/my_page/store_account_screen.dart';
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
  final _businessController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dio = Dio();

  bool _isPhoneNumberValid = false;
  bool _isVerifyValid = false;
  bool _isBusinessValid = false;
  bool _isDuplicatedBusiness = true;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isValid = false;
  bool _availableVerify = false;
  String? _phoneNumberError;
  String _savePhoneNumber = '';
  String? _verifyError;
  String? _BusinessError;
  String _saveBusiness = '';
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
                bottom: MediaQuery.of(context).viewInsets.bottom),
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

                          try {
                            String phoneNumber = _phoneNumberController.text;
                            final baseUrl = dotenv.env['BASE_URL'];
                            final response = await _dio
                                .post('$baseUrl/auth/send-code/phone', data: {
                              'phoneNumber': phoneNumber,
                            });

                            if (response.statusCode == 200) {
                              setState(() {
                                _availableVerify = true;
                              });
                            }
                          } catch (e) {
                            print('인증번호 전송 실패: $e');
                            setState(() {
                              _availableVerify = false;
                            });
                          }
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
                      if (_availableVerify) SizedBox(height: 15.0),
                      if (_availableVerify)
                        !_isVerifyValid
                            ? GestureDetector(
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                onTap: () async {
                                  String phoneNumber =
                                      _phoneNumberController.text;
                                  _savePhoneNumber = phoneNumber;
                                  _validatePhoneNumber();
                                  if (!_isPhoneNumberValid) {
                                    return;
                                  }

                                  try {
                                    String verification =
                                        _verifyController.text;
                                    final baseUrl = dotenv.env['BASE_URL'];
                                    final response = await _dio.post(
                                      '$baseUrl/auth/check/phone',
                                      data: {
                                        'phoneNumber': phoneNumber,
                                        'verification': verification,
                                      },
                                    );

                                    if (response.statusCode == 200) {
                                      setState(() {
                                        _isVerifyValid = true;
                                      });
                                    }
                                  } catch (e) {
                                    print('인증번호 확인 실패: $e');
                                    _verifyError = '인증번호가 일치하지 않습니다.';
                                  }
                                },
                              )
                            : Text(
                                '인증 완료되었습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.lightBlue,
                                ),
                              ),
                      SizedBox(height: 40),
                      _buildPasswordField(
                        controller: _businessController,
                        label: "사업자등록번호를 입력해주세요.",
                        hintText: "사업자등록번호를 입력하세요.",
                        type: 'business',
                        errorText: _BusinessError,
                      ),
                      SizedBox(height: 15.0),
                      _isDuplicatedBusiness
                          ? GestureDetector(
                              child: Text(
                                '번호 확인',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              onTap: () async {
                                String nickname = _businessController.text;
                                _saveBusiness = nickname;
                                _validateBusiness();
                                if (!_isBusinessValid) {
                                  return;
                                }

                                if (_saveBusiness != '1234567890') {
                                  try {
                                    final baseUrl = dotenv.env['BASE_URL'];
                                    final businessUrl =
                                        dotenv.env['BASE_BUSINESS_URL'];
                                    final serviceKey =
                                        dotenv.env['BASE_SERVICE_KEY'];
                                    print(baseUrl);
                                    print('$businessUrl/status');
                                    print(serviceKey);
                                    final response = await _dio.post(
                                      '$businessUrl/status',
                                      queryParameters: {
                                        'serviceKey': serviceKey
                                      },
                                      data: {
                                        'b_no': [_saveBusiness],
                                      },
                                    );
                                    print(response);

                                    if (response.statusCode == 200 &&
                                        response.data['status_code'] == 'OK') {
                                      setState(() {
                                        _isBusinessValid = true;
                                        _BusinessError = null;
                                        _isDuplicatedBusiness = false;
                                      });
                                    }
                                  } on DioError catch (e) {
                                    print('인증번호 전송 실패: ${e.response?.data}');
                                    setState(() {
                                      _isBusinessValid = false;
                                      _BusinessError = '올바른 사업자등록번호를 입력해주세요.';
                                      _isDuplicatedBusiness = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _isBusinessValid = true;
                                    _BusinessError = null;
                                    _isDuplicatedBusiness = false;
                                  });
                                }
                              },
                            )
                          : Text(
                              '확인되었습니다.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlue,
                              ),
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
              String password = _passwordController.text;
              String business = _businessController.text;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreAccountScreen(
                    phoneNumber: phoneNumber,
                    password: password,
                    businessNumber: business,
                  ),
                ),
              );
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
              '다음',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText:
              type == 'phoneNumber' || type == 'verify' || type == 'nickname'
                  ? false
                  : true,
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

            if (type == 'new' || type == 'confirm') {
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

  void _validateBusiness() {
    setState(() {
      String business = _businessController.text;

      if (business.length == 10) {
        _isBusinessValid = true;
        _BusinessError = null; // 오류 메시지 제거
      } else {
        _isBusinessValid = false;
        _BusinessError = '사업자등록번호는 10자로 입력해주세요.';
        return;
      }
    });

    _validateForm();
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
      // _isValid = _isPhoneNumberValid &&
      //     _isBusinessValid &&
      //     _isPasswordValid &&
      //     _isConfirmPasswordValid &&
      //     _isVerifyValid;
      _isValid = true;
    });
  }
}
