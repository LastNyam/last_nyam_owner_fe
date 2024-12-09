import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/categories.dart';
import 'package:last_nyam_owner/const/colors.dart';

class Category extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Category({super.key, required this.onCategorySelected});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String selectedType = 'all'; // 초기 선택은 "전체"

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35, // 카테고리 버튼의 높이
      alignment: Alignment.centerLeft, // 왼쪽 정렬
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
        children: categories.map((category) {
          bool isSelected = category.type == selectedType; // 선택된 상태 확인

          return Padding(
            padding: const EdgeInsets.only(right: 10.0), // 버튼 간격 조정
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedType = category.type; // 선택된 카테고리 타입 설정
                });
                widget.onCategorySelected(selectedType); // 선택된 카테고리 콜백 호출
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Color(0xff417c4e) // 선택된 버튼 색상
                    : Color(0xfffafafa), // 비선택 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                category.text,
                style: TextStyle(
                    color: isSelected
                        ? Color(0xfffafafa) // 선택된 텍스트 색상
                        : Color(0xffb9c6bc), // 비선택 텍스트 색상
                    fontSize: 15
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
