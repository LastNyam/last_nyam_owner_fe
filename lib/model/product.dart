class PostedProduct {
  final int foodId; // 상품 ID
  final String foodCategory; // 상품 카테고리
  final String foodName; // 상품 이름
  final int originPrice; // 원가
  final int discountPrice; // 할인된 가격
  final DateTime endTime; // 마감 시간
  final String status; // 상품 상태 (예: AVAILABLE)
  final String image; // Base64로 인코딩된 이미지
  bool isHidden;
  bool isSoldout;

  PostedProduct({
    required this.foodId,
    required this.foodCategory,
    required this.foodName,
    required this.originPrice,
    required this.discountPrice,
    required this.endTime,
    required this.status,
    required this.image,
    this.isHidden = false,
    this.isSoldout = false,
  });

  // JSON 데이터를 Product 객체로 변환하는 팩토리 생성자
  factory PostedProduct.fromJson(Map<String, dynamic> json) {
    return PostedProduct(
      foodId: json['foodId'],
      foodCategory: json['foodCategory'],
      foodName: json['foodName'],
      originPrice: json['originPrice'],
      discountPrice: json['discountPrice'],
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      image: json['image'],
    );
  }

  // Product 객체를 JSON으로 변환 (필요 시)
  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodCategory': foodCategory,
      'foodName': foodName,
      'originPrice': originPrice,
      'discountPrice': discountPrice,
      'endTime': endTime.toIso8601String(),
      'status': status,
      'image': image,
    };
  }
}

// lib/model/product.dart

class PostingProduct {
  final String foodCategory; // 음식 카테고리
  final String foodName; // 음식 이름
  final String content; // 설명
  final int originPrice; // 원가격
  final int discountPrice; // 할인가격
  final String endTime; // 마감 시간 (ISO 8601 형식)
  final int reservationTime; // 예약 시간
  final String recipe; // 레시피
  final String recipeImage; // 레시피 사진 (Base64 인코딩된 문자열)
  final String foodImage; // 음식 사진 (Base64 인코딩된 문자열)

  PostingProduct({
    required this.foodCategory,
    required this.foodName,
    required this.content,
    required this.originPrice,
    required this.discountPrice,
    required this.endTime,
    required this.reservationTime,
    required this.recipe,
    required this.recipeImage,
    required this.foodImage,
  });

  // JSON 데이터를 PostingProduct 객체로 변환하는 팩토리 생성자
  factory PostingProduct.fromJson(Map<String, dynamic> json) {
    return PostingProduct(
      foodCategory: json['foodCategory'] ?? '',
      foodName: json['foodName'] ?? '',
      content: json['content'] ?? '',
      originPrice: json['originPrice'] is int
          ? json['originPrice']
          : int.tryParse(json['originPrice'].toString()) ?? 0,
      discountPrice: json['discountPrice'] is int
          ? json['discountPrice']
          : int.tryParse(json['discountPrice'].toString()) ?? 0,
      endTime: json['endTime'] ?? '',
      reservationTime: json['reservationTime'] is int
          ? json['reservationTime']
          : int.tryParse(json['reservationTime'].toString()) ?? 0,
      recipe: json['recipe'] ?? '',
      recipeImage: json['recipeImage'] ?? '',
      foodImage: json['foodImage'] ?? '',
    );
  }

  // PostingProduct 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'foodCategory': foodCategory,
      'foodName': foodName,
      'content': content,
      'originPrice': originPrice,
      'discountPrice': discountPrice,
      'endTime': endTime,
      'reservationTime': reservationTime,
      'recipe': recipe,
      'recipeImage': recipeImage,
      'foodImage': foodImage,
    };
  }
}
