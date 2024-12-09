import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:last_nyam_owner/const/colors.dart';

class AddressChangeScreen extends StatefulWidget {
  const AddressChangeScreen({Key? key}) : super(key: key);

  @override
  _AddressChangeScreenState createState() => _AddressChangeScreenState();
}

class _AddressChangeScreenState extends State<AddressChangeScreen> {
  final TextEditingController _addressController = TextEditingController();
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  final _storage = const FlutterSecureStorage();

  bool _isAddressValid = true;
  String _addressError = '';

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
        await _sendCoordinatesToServer(context, address, latitude, longitude);
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

  Future<void> _sendCoordinatesToServer(BuildContext context, String address,
      String latitude, String longitude) async {
    final baseUrl = dotenv.env['BASE_URL'];
    String? token = await _storage.read(key: 'authToken');

    try {
      final response = await _dio.patch(
        '$baseUrl/store/address',
        data: {
          'address': address,
          'posX': latitude,
          'posY': longitude,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("서버 응답 오류: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("서버 요청 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "주소 변경",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "새로운 주소를 입력해주세요",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "도로명 주소를 입력하세요",
                  filled: true,
                  fillColor: defaultColors['white'],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.transparent : Color(0xff417c4e),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.transparent : Color(0xff417c4e),
                      width: 2.0,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
              if (!_isAddressValid) ...[
                SizedBox(height: 8.0),
                Text(
                  _addressError!,
                  style: TextStyle(
                    color: defaultColors['green'],
                    fontSize: 14,
                  ),
                ),
              ],
              Spacer(), // 하단에 버튼을 배치하기 위해 공간 사용
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _getCoordinatesAndSendRequest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['green'], // 버튼 색상
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "변경 완료",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
