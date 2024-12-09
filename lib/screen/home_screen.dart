import 'package:flutter/material.dart';
import 'package:last_nyam_owner/component/home/category.dart';
import 'package:last_nyam_owner/screen/hide.dart';
import 'package:last_nyam_owner/screen/sold_out.dart';
import 'package:last_nyam_owner/screen/product_add.dart';
import 'package:last_nyam_owner/const/colors.dart';

// 1000원 표시 ','
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Product {
  final String category;
  final String title;
  final String price;
  final String discount;
  final String imagePath;
  final String timeLeft;
  bool isSoldout = false;
  bool isHiden = false;

  Product({
    required this.category,
    required this.title,
    required this.price,
    required this.discount,
    required this.imagePath,
    required this.timeLeft,
    required this.isSoldout,
    required this.isHiden,
  });
}

class ContentCard extends StatelessWidget {
  final Product product;
  final bool isSelected; // isSelected 추가

  const ContentCard({super.key, required this.product, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    // 할인된 가격 계산
    int discountedPrice = 0;
    try {
      discountedPrice = (int.parse(product.price.replaceAll(RegExp(r'[^0-9]'), '')) *
          (100 - int.parse(product.discount.replaceAll('%', '')))) ~/
          100;
    } catch (e) {
      discountedPrice = 0;
    }

    // 숫자에 쉼표 추가
    final formattedOriginalPrice = NumberFormat("#,###").format(
      int.parse(product.price.replaceAll(RegExp(r'[^0-9]'), '')),
    );
    final formattedDiscountedPrice = NumberFormat("#,###").format(discountedPrice);


    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      constraints: const BoxConstraints(maxWidth: 350),
      margin: const EdgeInsets.symmetric(vertical: 7),

      decoration: ShapeDecoration(
        color: Color(0xfffafafa),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카테고리 텍스트
                    Text(
                      product.category == 'ingredients' ? '식자재' : '완제품',
                      style: const TextStyle(
                        color: Color(0xffb9c6bc),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 9),

                    // 상품 제목
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 할인율 및 가격 정보
                    Row(
                      children: [
                        Text(
                          product.discount,
                          style: const TextStyle(
                            color: Color(0xFF417C4E),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$formattedDiscountedPrice원',
                          style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    // 남은 시간
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/alarm.png',
                          width: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.timeLeft,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                child: Image.asset(
                  product.imagePath,
                  width: 100,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )),
          // 품절, 숨김 상태 모두 적용된 경우 아이콘 표시
          // if (product.isSoldout && product.isHiden)
          //   Positioned.fill(
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: const Color(0xff417c4e).withOpacity(0.7),
          //         borderRadius: BorderRadius.circular(13),
          //       ),
          //       child: Center(
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Icon(
          //               Icons.pause_circle_outline,
          //               color: const Color(0xfffafafa),
          //               size: 26,
          //             ),
          //             const SizedBox(width: 10),
          //             Icon(
          //               Icons.visibility_off,
          //               color: const Color(0xfffafafa),
          //               size: 26,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // 품절 처리 했을 때
          if (product.isSoldout)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff417c4e).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Icon(
                    Icons.pause_circle_outline,
                    color: Color(0xfffafafa),
                    size: 26,
                  ),
                ),
              ),
            ),
          // 숨김 처리 했을 때
          if (product.isHiden)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff417c4e).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Icon(
                    Icons.visibility_off,
                    color: Color(0xfffafafa),
                    size: 26,
                  ),
                ),
              ),
            ),
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF417C4E),
                    width: 4,  // 테두리 두께 조정
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

  List<Product> products = [
    Product(
      category: 'product',
      title: '마라로제 떡볶이',
      price: '12,100원',
      discount: '10%',
      imagePath: 'assets/image/mara_roze.png',
      timeLeft: '54분',
      isSoldout: false,
      isHiden: false,
    ),
    Product(
      category: 'ingredients',
      title: '깐 메추리알',
      price: '4,900원',
      discount: '5%',
      imagePath: 'assets/image/eggs.webp',
      timeLeft: '10시간',
      isSoldout: false,
      isHiden: false,
    ),
  ];

  List<Product> getFilteredProducts() {
    if (selectedCategory == 'all') {
      return products;
    }
    return products
        .where((product) =>
    product.category.trim().toLowerCase() ==
        selectedCategory.trim().toLowerCase())
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
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
          Divider(
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
                        builder: (context) => SoldOutScreen(products: products),
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['pureWhite'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조절
                    children: [
                      const Icon(Icons.pause_circle_outline, size: 16),
                      const SizedBox(width: 4), // 아이콘과 텍스트 간격 조정
                      const Text(
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
                      MaterialPageRoute(builder: (context) => HiddenScreen(products: products)),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['pureWhite'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조절
                    children: [
                      const Icon(Icons.visibility_off, size: 16), // 숨김 아이콘
                      const SizedBox(width: 4), // 아이콘과 텍스트 간격
                      const Text(
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
                      MaterialPageRoute(builder: (context) => AddProductScreen()
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColors['green'],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 16, color: Color(0xfffafafa),), // 플러스 아이콘 추가
                      const SizedBox(width: 4), // 아이콘과 텍스트 간격
                      const Text(
                        '상품 추가',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xfffafafa)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 본문 내용: 필터링된 ContentCard 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: getFilteredProducts().length,
              itemBuilder: (context, index) {
                return ContentCard(product: getFilteredProducts()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
