import 'dart:typed_data';
import 'dart:convert'; // Base64 디코딩을 위해 필요

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/product.dart';

class BackendAPI {
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // 내 상품 조회
  Future<List<Map<String, dynamic>>> fetchMyProducts() async {
    try {
      // BASE_URL 가져오기
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }
      // 인증 토큰 읽기
      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // GET 요청 보내기
      final response = await _dio.get(
        '$baseUrl/food',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          final List<dynamic> productList = responseData['data'];
          return productList.map((product) => product as Map<String, dynamic>).toList();
        } else {
          throw Exception('상품 데이터를 가져오지 못했습니다.');
        }
      } else {
        throw Exception('서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('내 상품 조회 실패: $e');
      throw Exception('내 상품 조회 요청 중 문제가 발생했습니다.');
    }
  }





  Future<PostedProduct> addProduct(PostingProduct product) async {
    try {
      // BASE_URL 가져오기
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      // 인증 토큰 읽기
      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // FormData 생성
      FormData formData = FormData.fromMap({
        'foodCategory': product.foodCategory,
        'foodName': product.foodName,
        'content': product.content,
        'originPrice': product.originPrice,
        'discountPrice': product.discountPrice,
        'endTime': product.endTime,
        'reservationTime': product.reservationTime,
        'recipe': product.recipe,
        if (product.foodImage.isNotEmpty)
          'foodImage': MultipartFile.fromBytes(
            base64Decode(product.foodImage),
            filename: 'food_image_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
        if (product.recipeImage.isNotEmpty)
          'recipeImage': MultipartFile.fromBytes(
            base64Decode(product.recipeImage),
            filename: 'recipe_image_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
      });

      // 요청 및 응답 로깅
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));

      // POST 요청 보내기
      final response = await _dio.post(
        '$baseUrl/food',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // 응답 처리
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          final Map<String, dynamic> data = responseData['data'];
          return PostedProduct.fromJson(data);
        } else {
          throw Exception('상품 추가에 실패했습니다: ${responseData['message']}');
        }
      } else {
        throw Exception(
            '서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('상품 추가 실패: $e');
      throw Exception('상품 추가 요청 중 문제가 발생했습니다.');
    }
  }
}