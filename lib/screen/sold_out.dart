import 'package:flutter/material.dart';
import 'home_screen.dart'; // Product 클래스가 정의된 파일을 정확하게 import하세요.
import 'package:last_nyam_owner/model/product.dart';

class SoldOutScreen extends StatefulWidget {
  final List<PostedProduct> products;

  const SoldOutScreen({Key? key, required this.products}) : super(key: key);

  @override
  _SoldOutScreenState createState() => _SoldOutScreenState();
}

class _SoldOutScreenState extends State<SoldOutScreen> {
  List<int> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    // 원본 products 리스트의 인덱스를 보존하기 위해 asMap과 entries 사용
    final availableProducts = widget.products
        .asMap()
        .entries
        .where((entry) => !entry.value.isSoldout)
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 제거
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 뒤로가기 버튼
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // 데이터 반환 불필요
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                // 품절하기 버튼
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var index in selectedItems) {
                        // 원본 products 리스트의 정확한 인덱스로 접근
                        final productIndex = availableProducts[index].key;
                        widget.products[productIndex].isSoldout = true;
                      }
                      selectedItems.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('품절 처리 완료')),
                    );
                    Navigator.pop(context); // 변경 사항 반영 후 화면 종료
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF417C4E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    '품절하기',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: availableProducts.isEmpty
          ? const Center(
        child: Text(
          '품절 처리 가능한 상품이 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availableProducts.length,
        itemBuilder: (context, index) {
          final productEntry = availableProducts[index];
          final product = productEntry.value;
          final isSelected = selectedItems.contains(index);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedItems.remove(index);
                } else {
                  selectedItems.add(index);
                }
              });
            },
            child: Container(
              child: ClipRRect(
                child: ContentCard(
                  product: product,
                  isSelected: isSelected,
                  // isSelected 전달
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}