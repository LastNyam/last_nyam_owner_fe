// lib/screen/home_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:last_nyam_owner/component/home/category.dart';
import 'package:last_nyam_owner/screen/hide.dart';
import 'package:last_nyam_owner/screen/sold_out.dart';
import 'package:last_nyam_owner/screen/product_add.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/model/product.dart';
import 'package:last_nyam_owner/service/backend_api.dart';

// 1000원 표시 ','
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ContentCard extends StatelessWidget {
  final PostedProduct product;
  final bool isSelected; // isSelected 추가

  const ContentCard({super.key, required this.product, this.isSelected = false});

  // 남은 시간 계산
  String calculateTimeLeft(DateTime endTime) {
    final now = DateTime.now();
    final difference = endTime.difference(now);

    if (difference.isNegative) {
      return '마감';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}일';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간';
    } else {
      return '${difference.inMinutes}분';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 할인율 계산
    double discountRate = 0.0;
    if (product.originPrice > 0) {
      discountRate =
          ((product.originPrice - product.discountPrice) / product.originPrice) * 100;
    }

    // 숫자에 쉼표 추가
    final formattedOriginalPrice = NumberFormat("#,###").format(product.originPrice);
    final formattedDiscountedPrice = NumberFormat("#,###").format(product.discountPrice);

    // 남은 시간
    final timeLeft = calculateTimeLeft(product.endTime);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 350),
      margin: const EdgeInsets.symmetric(vertical: 5), // 여백 축소
      decoration: ShapeDecoration(
        color: const Color(0xfffafafa),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 패딩 축소
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카테고리 텍스트
                      Text(
                        product.foodCategory.toLowerCase() == 'ingredients'
                            ? '식자재'
                            : '완제품',
                        style: const TextStyle(
                          color: Color(0xffb9c6bc),
                          fontSize: 9, // 폰트 크기 축소
                        ),
                      ),
                      const SizedBox(height: 6), // 간격 축소

                      // 상품 제목
                      Text(
                        product.foodName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 10, // 폰트 크기 축소
                        ),
                      ),
                      const SizedBox(height: 3), // 간격 축소

                      // 할인율 및 가격 정보
                      Row(
                        children: [
                          Text(
                            '${discountRate.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Color(0xFF417C4E),
                              fontSize: 13, // 폰트 크기 축소
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedDiscountedPrice원',
                            style: const TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 13, // 폰트 크기 축소
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3), // 간격 축소

                      // 남은 시간
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/alarm.png',
                            width: 11, // 아이콘 크기 축소
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeLeft,
                            style: const TextStyle(
                              fontSize: 10, // 폰트 크기 축소
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.image.isNotEmpty
                      ? Image.memory(
                    base64Decode(product.image),
                    width: 80, // 이미지 크기 축소
                    height: 60, // 이미지 크기 축소
                    fit: BoxFit.cover,
                  )
                      : const SizedBox(
                    width: 80,
                    height: 60,
                    child: Center(child: Text('이미지 없음')),
                  ),
                ),
              ],
            ),
          ),
          // 품절 처리 했을 때
          if (product.status.toUpperCase() == 'SOLD_OUT')
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff417c4e).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Icon(
                    Icons.pause_circle_outline,
                    color: Color(0xfffafafa),
                    size: 24, // 아이콘 크기 축소
                  ),
                ),
              ),
            ),
          // 숨김 처리 했을 때
          if (product.status.toUpperCase() == 'HIDDEN')
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff417c4e).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Icon(
                    Icons.visibility_off,
                    color: Color(0xfffafafa),
                    size: 24, // 아이콘 크기 축소
                  ),
                ),
              ),
            ),
          // 선택된 경우 테두리 표시
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF417C4E),
                    width: 3, // 테두리 두께 축소
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
        ],
      ),
    );

  }
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'all'; // 상단 카테고리 선택 상태
  final BackendAPI _backendAPI = BackendAPI();

  List<PostedProduct> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // 상품 데이터 가져오기
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await _backendAPI.fetchMyProducts();
      // Convert fetched data to Product objects
      final List<PostedProduct> loadedProducts = fetchedProducts.map((json) {
        return PostedProduct.fromJson(json);
      }).toList();

      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('상품 데이터 가져오기 실패: $e');
      setState(() {
        isLoading = false;
        errorMessage = '상품 데이터를 불러오는 데 실패했습니다.';
      });
    }
  }

  // 카테고리 필터링된 상품 리스트
  List<PostedProduct> getFilteredProducts() {
    if (selectedCategory == 'all') {
      return products;
    }
    return products
        .where((product) =>
    product.foodCategory.trim().toLowerCase() ==
        selectedCategory.trim().toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        // 카테고리 위젯 추가
        title: Category(
          onCategorySelected: (String categoryType) {
            setState(() {
              selectedCategory = categoryType;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/search.png',
              width: 24,
            ),
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: ProductSearchDelegate(products),
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: Color(0xffb9c6bc),
            thickness: 0.1,
          ),

          // 품절, 숨김, 상품 추가 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 품절 버튼
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SoldOutScreen(products: products),
                      ),
                    );
                    fetchProducts(); // 데이터 다시 로드
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['pureWhite'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조절
                    children: const [
                      Icon(Icons.pause_circle_outline, size: 16),
                      SizedBox(width: 4), // 아이콘과 텍스트 간격 조정
                      Text(
                        '품절',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 숨김 버튼
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HiddenScreen(products: products)),
                    );
                    fetchProducts(); // 데이터 다시 로드
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['pureWhite'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조절
                    children: const [
                      Icon(Icons.visibility_off, size: 16), // 숨김 아이콘
                      SizedBox(width: 4), // 아이콘과 텍스트 간격
                      Text(
                        '숨김',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 상품 추가 버튼
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductScreen()),
                    );
                    fetchProducts(); // 데이터 다시 로드
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['green'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xfffafafa),
                      ), // 플러스 아이콘 추가
                      SizedBox(width: 4), // 아이콘과 텍스트 간격
                      Text(
                        '상품 추가',
                        style: TextStyle(
                            fontSize: 15, color: Color(0xfffafafa)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 본문 내용: 로딩, 오류, 필터링된 ContentCard 리스트
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(
                    color: Colors.red, fontSize: 16),
              ),
            )
                : products.isEmpty
                ? const Center(child: Text('등록된 상품이 없습니다.'))
                : GridView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // 한 행에 2개씩 표시
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 3 / 4,
              ),
              itemCount: getFilteredProducts().length,
              itemBuilder: (context, index) {
                final product = getFilteredProducts()[index];
                return ContentCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
