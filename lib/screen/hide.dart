import 'package:flutter/material.dart';
import 'home_screen.dart'; // Product 클래스가 정의된 파일을 import하세요.

class HiddenScreen extends StatefulWidget {
  final List<Product> products;

  const HiddenScreen({Key? key, required this.products}) : super(key: key);

  @override
  _HiddenScreenState createState() => _HiddenScreenState();
}

class _HiddenScreenState extends State<HiddenScreen> {
  List<int> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    // 모든 상품의 인덱스를 유지하기 위해 asMap과 entries 사용
    final productsWithIndex = widget.products.asMap().entries.toList();

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
                    Navigator.pop(context); // 화면 종료
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                // 숨김 상태 변경 버튼
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var index in selectedItems) {
                        // 원본 products 리스트의 정확한 인덱스로 접근
                        final productIndex = productsWithIndex[index].key;
                        widget.products[productIndex].isHiden =
                        !widget.products[productIndex].isHiden;
                      }
                      selectedItems.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('숨김 상태 변경 완료')),
                    );
                    Navigator.pop(context);
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
                    '숨김 상태 변경',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: productsWithIndex.isEmpty
          ? const Center(
        child: Text(
          '상품이 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: productsWithIndex.length,
        itemBuilder: (context, index) {
          final productEntry = productsWithIndex[index];
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
