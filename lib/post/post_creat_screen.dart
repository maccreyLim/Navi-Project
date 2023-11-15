import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/Widget/post_firebase.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/post_model.dart';
import 'package:navi_project/post/Image_picker_screen.dart';
import 'package:navi_project/post/post_screen.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class PostCreatScreen extends StatefulWidget {
  const PostCreatScreen({Key? key});

  @override
  State<PostCreatScreen> createState() => _PostCreatScreenState();
}

class _PostCreatScreenState extends State<PostCreatScreen> {
  // 필요한 속성(Property) 선언
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ControllerGetX());
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  late FirebaseStorage storage;
  Reference? storageReference; // Null safety
  List<XFile?> images = [];
  String? documentFileID;

  @override
  void initState() {
    super.initState();
    storage = FirebaseStorage.instance;
  }

  Future<List<String>> uploadImagesToFirebase(
      List<XFile?> images, String documentFileID) async {
    List<String> imageUrls = [];

    // DocumentReference를 얻은 후에 storageReference를 초기화
    storageReference = storage.ref().child("postimages/$documentFileID/");

    for (int index = 0; index < images.length; index++) {
      if (images[index] != null) {
        ByteData byteData = await images[index]!.readAsBytes().then((value) {
          return ByteData.sublistView(Uint8List.fromList(value));
        });

        String storagePath = "post_image_$index.jpg";

        UploadTask uploadTask = storageReference!
            .child(storagePath)
            .putData(byteData.buffer.asUint8List());

        await uploadTask.whenComplete(() async {
          String imageUrl =
              await storageReference!.child(storagePath).getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }
    }

    return imageUrls;
  }

  String generateDocumentID() {
    final uuid = Uuid();
    return uuid.v4();
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: images
                        .asMap()
                        .entries
                        .map(
                          (entry) => Column(
                            children: [
                              if (entry.value != null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(entry
                                          .value!.path)), // 이미지를 파일로 변환하여 표시
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                // 이미지 리스트를 보여주는 부분 끝
                IconButton(
                  onPressed: () async {
                    final selectedImages = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePickerScreen(
                          picker: ImagePicker(),
                          pickedImages: images,
                        ),
                      ),
                    );

                    if (selectedImages != null) {
                      setState(() {
                        images = selectedImages;
                      });
                    }
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
                      String documentFileID = generateDocumentID();
                      if (_formKey.currentState!.validate()) {
                        List<String> imageUrls = await uploadImagesToFirebase(
                            images, documentFileID);

                        PostModel post = PostModel(
                          authorUid: controller.userUid,
                          authorNickname: controller.userData['nickName'] ?? "",
                          isLiked: false,
                          likeCount: 0,
                          title: titleController.text,
                          content: contentsController.text,
                          createdAt: DateTime.now(),
                          updatedAt: null,
                          photoUrls: imageUrls.isNotEmpty ? imageUrls : [],
                          documentFileID: documentFileID!,
                        );

                        await PostFirebaseService()
                            .createPost(post, documentFileID);

                        ShowToast('게시물이 성공적으로 저장되었습니다.', 1);
                        Get.off(PostScreen());
                      }
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
