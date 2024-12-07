// product_add.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 추가
import 'dart:io'; // 파일 처리를 위해 추가

import 'home_screen.dart'; // Product 클래스 import

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  int _quantity = 1; // 수량
  String _selectedEndTimeOption = '직접입력'; // 마감 시간 옵션

  File? _imageFile; // 선택된 이미지 파일
  final ImagePicker _picker = ImagePicker(); // ImagePicker 인스턴스

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // 선택된 이미지 파일 저장
      });
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품 정보
            const Text(
              '상품 정보',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage, // 이미지 선택 기능 연결
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                )
                    : const Center(
                  child: Icon(Icons.camera_alt, color: Colors.grey, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '상품명',
                border: UnderlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 14), // 폰트 크기 조정
            ),
            const SizedBox(height: 16),

            // 설명
            const Text(
              '설명',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '상품 설명을 최대한 자세히 적어주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(fontSize: 14), // 폰트 크기 조정
            ),
            const SizedBox(height: 16),

            // 가격
            const Text(
              '가격',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '₩ 정가',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(fontSize: 14), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _discountPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '₩ 판매가',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(fontSize: 14), // 폰트 크기 조정
            ),
            const SizedBox(height: 16),

            // 수량
            const Text(
              '수량',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) _quantity--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontSize: 14), // 폰트 크기 조정
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 상품 마감 시간
            const Text(
              '상품 마감 시간',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 폰트 크기 조정
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: '직접입력',
                    groupValue: _selectedEndTimeOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedEndTimeOption = value.toString();
                      });
                    },
                    title: const Text('직접입력', style: TextStyle(fontSize: 14)), // 폰트 크기 조정
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: '거래마감시간',
                    groupValue: _selectedEndTimeOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedEndTimeOption = value.toString();
                      });
                    },
                    title: const Text('거래마감시간', style: TextStyle(fontSize: 14)), // 폰트 크기 조정
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 상품 추가 버튼
            ElevatedButton(
              onPressed: () {
                // 데이터 검증 및 처리
                if (_titleController.text.isEmpty ||
                    _priceController.text.isEmpty ||
                    _discountPriceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
                  );
                  return;
                }

                // 새로운 Product 객체 생성
                final newProduct = Product(
                  category: '기타', // 임시 카테고리
                  title: _titleController.text,
                  price: '${_priceController.text}원',
                  discount: '${_discountPriceController.text}원',
                  imagePath: _imageFile != null ? _imageFile!.path : 'image/default.png',
                  timeLeft: _selectedEndTimeOption,
                  isSoldout: false,
                  isHiden: false,
                );

                // 이전 화면으로 돌아가면서 새로운 상품을 반환
                Navigator.pop(context, newProduct);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF417C4E),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Center(
                child: Text(
                  '상품 추가',
                  style: TextStyle(color: Colors.white, fontSize: 14), // 폰트 크기 조정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
