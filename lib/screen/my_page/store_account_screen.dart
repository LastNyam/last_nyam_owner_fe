import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';

class StoreAccountScreen extends StatefulWidget {
  final String phoneNumber;
  final String password;
  final String businessNumber;

  const StoreAccountScreen({
    Key? key,
    required this.phoneNumber,
    required this.password,
    required this.businessNumber,
  }) : super(key: key);

  @override
  _StoreAccountScreenState createState() => _StoreAccountScreenState();
}

class _StoreAccountScreenState extends State<StoreAccountScreen> {
  late String _businessNumber;
  late String _password;
  late String _phoneNumber;
  String? posX;
  String? posY;
  final _storeNameController = TextEditingController();
  final _callNumberController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isStoreNameValid = false;
  bool _isCallNumberValid = false;
  bool _isAddressValid = false;
  bool _isValid = false;
  String? _storeNameError;
  String? _callNumberError;
  String? _addressError;
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _businessNumber = widget.businessNumber;
    _password = widget.password;
    _phoneNumber = widget.phoneNumber;
  }

  Future<void> _getCoordinatesAndSendRequest(BuildContext context) async {
    String address = _addressController.text;

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("주소를 입력해주세요.")),
      );
      return;
    }

    try {
      // 주소 -> 위도/경도 변환
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        String latitude = locations.first.latitude.toString();
        String longitude = locations.first.longitude.toString();
        print('lat: $latitude');
        print('lon: $longitude');

        // 서버로 데이터 전송
        setState(() {
          posX = latitude;
          posY = longitude;
        });
      } else {
        setState(() {
          _isAddressValid = false;
          _addressError = '주소를 찾을 수 없습니다.';
        });
      }
    } catch (e) {
      print('주소 찾기 실패: $e');
      setState(() {
        _isAddressValid = false;
        _addressError = '주소를 찾을 수 없습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

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
          '가게 정보 등록',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordField(
                          controller: _storeNameController,
                          label: "가게 상호명을 입력해주세요.",
                          type: 'storeName',
                          hintText: "",
                          errorText: _storeNameError,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildPasswordField(
                          controller: _callNumberController,
                          label: "가게 번호를 입력해주세요.",
                          type: 'callNumber',
                          hintText: "054-123-4567",
                          errorText: _callNumberError,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildPasswordField(
                          controller: _addressController,
                          label: "가게 주소를 입력해주세요.",
                          type: 'address',
                          hintText: "도로명 주소 입력",
                          errorText: _addressError,
                        ),
                        Spacer(),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_isValid) {
                                String storeName = _storeNameController.text;
                                String callNumber = _callNumberController.text;
                                String address = _addressController.text;
                                await _getCoordinatesAndSendRequest(context);

                                try {
                                  final baseUrl = dotenv.env['BASE_URL'];
                                  String token = '';

                                  try {
                                    final response = await _dio.post(
                                      '$baseUrl/auth/signup',
                                      data: {
                                        'password': _password,
                                        'phoneNumber': _phoneNumber,
                                        'businessNumber': _businessNumber,
                                      },
                                    );

                                    if (response.statusCode == 200) {
                                      print('token: ${response.data['data']['token']}');
                                      token =
                                          response.data['data']['token'];
                                    }
                                  } on DioError catch (e) {
                                    print('회원가입 실패: ${e.response?.data}');
                                  }

                                  final formData = FormData.fromMap({
                                    'storeName': storeName,
                                    'businessNumber': _businessNumber,
                                    'callNumber': callNumber,
                                    'address': address,
                                    'posX': posX,
                                    'posY': posY,
                                  });

                                  final response = await _dio.post(
                                    '$baseUrl/store',
                                    data: formData,
                                    options: Options(
                                      headers: {
                                        'Authorization': 'Bearer ${token}'
                                      },
                                      contentType: 'multipart/form-data',
                                    ),
                                  );

                                  if (response.statusCode == 200) {
                                    Navigator.pop(context); // 변경 후 이전 화면으로 이동
                                  }
                                } on DioError catch (e) {
                                  print('가게 등록 실패: ${e.response?.data}');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isValid
                                  ? defaultColors['green']
                                  : defaultColors['lightGreen'], // 버튼 색상
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.0), // Border radius 설정
                              ),
                            ),
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
            if (type == 'callNumber') {
              _validateCallNumber();
            }

            if (type == 'storeName') {
              _validateStoreName();
            }

            _validateForm();
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

  void _validateCallNumber() {
    String callNumber = _callNumberController.text;

    if (validateCallNumber(callNumber)) {
      setState(() {
        _isCallNumberValid = true;
        _callNumberError = null;
      });
    } else {
      setState(() {
        _isCallNumberValid = false;
        _callNumberError = '유효한 가게번호가 아닙니다.';
      });
    }
  }

  bool validateCallNumber(String callNumber) {
    RegExp callNumberRegex = RegExp(r'^0[0-9]{2}-[0-9]{3,4}-[0-9]{4}$');
    return callNumberRegex.hasMatch(callNumber);
  }

  void _validateStoreName() {
    String storeName = _storeNameController.text;

    if (storeName.length >= 0) {
      setState(() {
        _isStoreNameValid = true;
        _storeNameError = null;
      });
    } else {
      setState(() {
        _isStoreNameValid = false;
        _storeNameError = '가게 상호명을 입력해주세요.';
      });
    }
  }

  void _validateForm() {
    setState(() {
      _isValid = _isStoreNameValid && _isCallNumberValid;
    });
  }
}
