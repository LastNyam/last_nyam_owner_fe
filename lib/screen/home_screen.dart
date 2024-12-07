import 'package:flutter/material.dart';
import 'package:last_nyam_owner/component/home/category.dart';
import 'package:last_nyam_owner/screen/hide.dart';
import 'package:last_nyam_owner/screen/sold_out.dart';
import 'package:last_nyam_owner/screen/product_add.dart';



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

  const ContentCard({super.key, required this.product});

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 텍스트
                Text(
                  product.category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),


                    if (product.isSoldout)
                      const SizedBox(width: 8),
                    if (product.isSoldout)
                      const Text(
                        '품절',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    if (product.isHiden)
                      const SizedBox(width: 8),
                    if (product.isHiden)
                      const Text(
                        '숨김',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // 할인율 및 가격 정보
                Row(
                  children: [
                    Text(
                      product.discount,
                      style: const TextStyle(
                        color: Color(0xFF417C4E),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${discountedPrice.toString()}원',
                      style: const TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 남은 시간
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      product.timeLeft,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              product.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}


class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'all'; // 상단 카테고리 선택 상태

  final List<Product> products = [
    Product(
      category: '완제품',
      title: '마라로제 떡볶이',
      price: '12,100원',
      discount: '10%',
      imagePath: 'image/mara_roze.png',
      timeLeft: '54분',
      isSoldout: false,
      isHiden: false,
    ),
    Product(
      category: '식자재',
      title: '깐 메추리알',
      price: '4,900원',
      discount: '5%',
      imagePath: 'image/eggs.webp',
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
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 상단 카테고리
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Category(
                    onCategorySelected: (String categoryType) {
                      setState(() {
                        selectedCategory = categoryType;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () {
                    // 검색 기능 추가 가능
                  },
                ),
              ],
            ),
          ),

          // 품절, 숨김, 상품 추가 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [


                // 품절 버튼
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SoldOutScreen(products: products),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  label: const Text(
                    '품절',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),




                // 숨김 버튼
                ElevatedButton.icon(
                  onPressed: () async{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HiddenScreen(products: products)
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.visibility_off, size: 16, color: Colors.grey),
                  label: const Text(
                    '숨김',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  child: const Text(
                    '+ 상품 추가',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF417C4E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // 본문 내용: 필터링된 ContentCard 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
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


