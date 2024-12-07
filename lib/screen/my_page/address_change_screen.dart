import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:last_nyam_owner/const/colors.dart';

class AddressChangeScreen extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  final _storage = const FlutterSecureStorage();

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("주소를 찾을 수 없습니다.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("주소를 변환하는 데 실패했습니다: $e")),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("좌표가 성공적으로 전송되었습니다.")),
        );
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
                  hintText: "주소를 입력하세요",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
                        color: Colors.white),
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
