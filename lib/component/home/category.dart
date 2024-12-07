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
    // 카테고리 버튼의 높이
    double widgetHeight = MediaQuery.of(context).size.height * 0.1;

    return Container(
      height: widgetHeight,
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center, // 중앙 정렬
        spacing: 10.0, // 버튼 간의 가로 간격
        runSpacing: 10.0, // 줄 간의 세로 간격
        children: categories.map((category) {
          bool isSelected = category.type == selectedType; // 선택된 상태 확인

          return ElevatedButton(
            onPressed: () {
              setState(() {
                selectedType = category.type; // 선택된 카테고리 타입 설정
              });
              widget.onCategorySelected(selectedType); // 선택된 카테고리 콜백 호출
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? defaultColors['green'] // 선택된 버튼 색상
                  : defaultColors['white'], // 비선택 버튼 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              category.text,
              style: TextStyle(
                color: isSelected
                    ? defaultColors['pureWhite'] // 선택된 텍스트 색상
                    : defaultColors['lightGreen'], // 비선택 텍스트 색상
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
