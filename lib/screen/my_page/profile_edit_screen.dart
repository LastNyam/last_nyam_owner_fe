import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/screen/my_page/address_change_screen.dart';
import 'package:last_nyam_owner/screen/my_page/business_hour_screen.dart';
import 'package:last_nyam_owner/screen/my_page/store_number_change_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/screen/my_page/nickname_change_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _storage = const FlutterSecureStorage();
  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '가게 정보 수정',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // 프로필 이미지와 편집 아이콘
              GestureDetector(
                onTap: () => _showPhotoOptions(context), // 옵션 창 표시
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: defaultColors['white'],
                      backgroundImage: userState.profileImage != null
                          ? MemoryImage(userState.profileImage!) // 선택된 이미지
                          : AssetImage('assets/image/profile_image.png')
                              as ImageProvider, // 기본 이미지 프로필 이미지 경로
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: defaultColors['lightGreen'],
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 닉네임 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '상호명',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NicknameChangeScreen(
                                currentNickname: userState.userName),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            '${userState.userName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: defaultColors['lightGreen'],
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: defaultColors['lightGreen']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 30, thickness: 1, color: Colors.grey[200]),
              // 비밀번호 변경 섹션
              ListTile(
                title: Text(
                  '주소 변경',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: defaultColors['lightGreen']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressChangeScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  '가게 번호 변경',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: defaultColors['lightGreen']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreNumberChangeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 이미지 선택 동작
  Future<void> _pickImageFromGallery() async {
    final userState = Provider.of<UserState>(context, listen: false);
    final baseUrl = dotenv.env['BASE_URL']!;
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    MultipartFile file = await MultipartFile.fromFile(
      pickedImage!.path,
    );

    // FormData 생성
    FormData formData = FormData.fromMap({
      'file': file, // 서버에서 요구하는 필드 이름 확인
    });

    print(pickedImage!.path);
    String? token = await _storage.read(key: 'authToken');
    try {
      final response = await _dio.patch(
        '$baseUrl/store/image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        Uint8List? profileImage = await pickedImage.readAsBytes();
        userState.updateProfileImage(profileImage);
      }
    } catch (e) {
      print('이미지 업롣으 에러: $e');
    }
  }

  // 기본 이미지 적용
  void _applyDefaultImage() async {
    final userState = Provider.of<UserState>(context, listen: false);
    try {
      String? token = await _storage.read(key: 'authToken');
      final baseUrl = dotenv.env['BASE_URL']!;
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(Uint8List(0), filename: "assets/image/profile_image.png"),
      });
      final response = await _dio.patch(
        '$baseUrl/store/image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        userState.updateProfileImage(null);
      }
    } catch (e) {
      print('기본이미지 적용 실패: $e');
    }
  }

  // 프로필 사진 옵션 선택
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '프로필 사진 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: defaultColors['green']),
                title: Text('앨범에서 사진 선택'),
                onTap: () {
                  Navigator.pop(context); // 옵션 창 닫기
                  _pickImageFromGallery(); // 갤러리에서 사진 선택
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.image, color: defaultColors['green']),
                title: Text('기본 이미지 적용'),
                onTap: () {
                  Navigator.pop(context); // 옵션 창 닫기
                  _applyDefaultImage(); // 기본 이미지 적용
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
