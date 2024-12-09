import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 추가
import 'package:last_nyam_owner/const/colors.dart';
import 'dart:io'; // 파일 처리를 위해 추가
import 'home_screen.dart'; // Product 클래스 import
import 'package:intl/intl.dart'; // 숫자 포멧
import 'package:flutter/services.dart'; // TextInputFormatter를 위해 추가

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _recipeController = TextEditingController();

  // 수량 및 시간
  int _quantity = 1;
  int selectedHour = 0;
  int selectedMinute = 0;

  // 이미지 파일 관련
  File? _imageFile;
  File? _recipeImageFile;
  final ImagePicker _picker = ImagePicker();

  // 레시피 입력 폼 상태
  bool _showRecipeInput = false;

  // 숫자 포맷터
  final _numberFormatter = NumberFormat("#,###");

  @override
  void dispose() {
    // 컨트롤러 해제
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _recipeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickRecipeImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _recipeImageFile = File(pickedFile.path);
      });
    }
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return value;
    final number = int.tryParse(value.replaceAll(',', '')) ?? 0;
    return _numberFormatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 상품 추가'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xfffafafa),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductInfoSection(),
            _buildDivider(),
            _buildPriceSection(),
            _buildDivider(),
            _buildAdditionalOptionsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('상품 정보'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffb9c6bc)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.camera_alt, color: Color(0xffb9c6bc), size: 30)),
            ),
          ),
          const SizedBox(height: 30),
          _buildTextField(_titleController, '상품명'),
          const SizedBox(height: 50),
          const Text('설명'),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffb9c6bc).withOpacity(0.2),
              hintText: '섭취 및 구매 시 주의해야 할 점, 알러지 등 상품 설명을 적어주세요.',
              hintStyle: const TextStyle(color: Color(0xffb9c6bc), fontWeight: FontWeight.w300),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Divider(color: const Color(0xffb9c6bc).withOpacity(0.2), thickness: 8),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('가격'),
          const SizedBox(height: 8),
          _buildTextFieldWithPrefix(_priceController, '정가'),
          const SizedBox(height: 10),
          _buildTextFieldWithPrefix(_discountPriceController, '판매가'),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('수량'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (_quantity > 1) _quantity--;
                    }),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 14)),
                  IconButton(
                    onPressed: () => setState(() {
                      _quantity++;
                    }),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeSelection(),
          const SizedBox(height: 30),
          _buildRecipeSection(),
        ],
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('상품 마감 시간'),
        Row(
          children: [
            _buildDropdown(selectedHour, 24, (value) {
              if (value != null) {
                setState(() {
                  selectedHour = value;
                });
              }
            }),
            const SizedBox(width: 10),
            const Text(':'),
            const SizedBox(width: 10),
            _buildDropdown(selectedMinute, 60, (value) {
              if (value != null) {
                setState(() {
                  selectedMinute = value;
                });
              }
            }),
            const Text('까지', style: TextStyle(fontWeight: FontWeight.w300)),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('레시피 (선택)'),
            IconButton(
              icon: Icon(_showRecipeInput ? Icons.remove : Icons.add, color: const Color(0xFF417C4E)),
              onPressed: () => setState(() {
                _showRecipeInput = !_showRecipeInput;
              }),
            ),
          ],
        ),
        if (_showRecipeInput)
          Row(
            children: [
              // 사진 등록 부분
              GestureDetector(
                onTap: _pickRecipeImage,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffb9c6bc)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _recipeImageFile != null
                      ? Image.file(_recipeImageFile!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.camera_alt, color: Color(0xffb9c6bc), size: 30)),
                ),
              ),
              const SizedBox(width: 10), // 사진과 텍스트 입력 사이에 여백을 추가
              // 레시피 입력 부분
              Expanded(
                child: TextField(
                  controller: _recipeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffb9c6bc).withOpacity(0.2),
                    hintText: '상품을 더 맛있고 즐겁게 즐길 수 있는 사장님만의 레시피를 알려주세요.',
                    hintStyle: const TextStyle(color: Color(0xffb9c6bc), fontWeight: FontWeight.w300, fontSize: 12),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: const Color(0xfffafafa),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xff417c4e), width: 0.1), // 윗 테두리 설정
          ),
        ),
        child: ElevatedButton(
          onPressed: _onAddProductPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF417C4E),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: const Text(
            '상품 추가',
            style: TextStyle(color: Color(0xfff2f2f2), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xffb9c6bc), fontWeight: FontWeight.w300),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffb9c6bc))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff262626))),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffb9c6bc))),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildTextFieldWithPrefix(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          final formatted = _formatNumber(newValue.text);
          return newValue.copyWith(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }),
      ],
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20),
          child: Text('₩', style: TextStyle(fontSize: 14)),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xffb9c6bc), fontWeight: FontWeight.w300),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffb9c6bc))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff262626))),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffb9c6bc))),
        isDense: true,
        contentPadding: const EdgeInsets.only(top: 20, bottom: 0),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildDropdown(int selectedValue, int range, ValueChanged<int?> onChanged) {
    return DropdownButton<int>(
      value: selectedValue,
      items: List.generate(range, (index) => index).map((value) {
        return DropdownMenuItem(value: value, child: Text(value.toString().padLeft(2, '0')));
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _onAddProductPressed() {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _discountPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
      );
      return;
    }

    final newProduct = Product(
      category: '기타',
      title: _titleController.text,
      price: '${_priceController.text}원',
      discount: '${_discountPriceController.text}원',
      imagePath: _imageFile?.path ?? 'image/default.png',
      timeLeft: '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
      isSoldout: false,
      isHiden: false,
    );

    Navigator.pop(context, newProduct);
  }
}
