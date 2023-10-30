import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/post_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:navi_project/post/post_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class BoardCreatScreen extends StatefulWidget {
  const BoardCreatScreen({super.key});

  @override
  State<BoardCreatScreen> createState() => _BoardCreatScreenState();
}

class _BoardCreatScreenState extends State<BoardCreatScreen> {
  // 필요한 속성(Property) 선언
  final _formKey = GlobalKey<FormState>(); // 폼의 유효성 검사를 위한 키
  final controller = Get.put(ControllerGetX()); // GetX 컨트롤러 인스턴스
  TextEditingController titleController = TextEditingController(); // 제목 입력 컨트롤러
  TextEditingController contentsController =
      TextEditingController(); // 내용 입력 컨트롤러
  late FirebaseStorage storage; // Firebase Storage 객체
  late Reference storageReference; // Firebase Storage 레퍼런스
  List<Asset> images = <Asset>[]; // 선택된 이미지 목록
  String? documentFileID; // Declare documentFileID as nullable

  @override
  void initState() {
    super.initState();
    // Firebase Storage 초기화
    storage = FirebaseStorage.instance;
    storageReference = storage.ref().child("postimages/"); // 이미지를 저장할 경로 지정
  }

  //선택된 이미지표시
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  // 카메라/갤러리권한을 요청하는 함수
  Future<void> requestMultiImagePickerPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.photos] == PermissionStatus.granted) {
      // 권한이 모두 허용된 경우 MultiImagePicker를 사용할 수 있습니다.
      loadAssets();
      print("권한승인:${statuses}");
    } else {
      // 권한 거부 처리
      // 사용자에게 권한이 필요하다는 메시지를 표시하거나 설정 앱을 열어 권한을 부여할 수 있도록 안내
      openAppSettings();
      print("권한거부:${statuses}");
    }
  }

  // 이미지 업로드 및 Firestore에 저장하는 비동기 메서드
  Future<List<String>> uploadImagesToFirebase() async {
    List<String> imageUrls = [];

    for (int index = 0; index < images.length; index++) {
      ByteData byteData = await images[index].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      UploadTask uploadTask = storageReference
          .child("image_$index.jpg")
          .putData(Uint8List.fromList(imageData));

      await uploadTask.whenComplete(() async {
        String imageUrl =
            await storageReference.child("image_$index.jpg").getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }

    return imageUrls;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      ShowToast('$e', 1);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      ShowToast('에러', 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판 쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    hintText: '제목을 입력해 주세요',
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLines: 10,
                  controller: contentsController,
                  decoration: const InputDecoration(
                    labelText: '내용',
                    hintText: '내용을 입력해주세요',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해주세요';
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) {
                    contentsController.text = value;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                  onPressed: () {
                    // 이미지 선택 다이얼로그 열기
                    requestMultiImagePickerPermissions(); // 카메라 권한 요청 추가
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 35,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      List<String> imageUrls = await uploadImagesToFirebase();

                      PostModel post = PostModel(
                        authorUid: controller.userUid,
                        authorNickname: controller.userData['nickName'] ?? "",
                        isLiked: false,
                        likeCount: 0,
                        title: titleController.text,
                        content: contentsController.text,
                        createdAt: DateTime.now(),
                        photoUrls: imageUrls.isNotEmpty ? imageUrls : [],
                        documentFileID: "",
                      );

                      await PostFirebaseService().createPost(post);

                      ShowToast('게시물이 성공적으로 저장되었습니다.', 1);
                      Get.off(const PostScreen());
                    },
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
