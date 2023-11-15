// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:navi_project/GetX/getx.dart';
// import 'package:navi_project/Widget/post_firebase.dart';
// import 'package:navi_project/Widget/show_toast.dart';
// import 'package:navi_project/model/post_model.dart';
// import 'package:navi_project/post/Image_picker_screen.dart';
// import 'package:navi_project/post/post_screen.dart';
// import 'dart:io';
// import 'package:uuid/uuid.dart';
// import 'package:image/image.dart' as img;
// import 'package:http/http.dart' as http;

// class PostUpdateScreen extends StatefulWidget {
//   final PostModel post;
//   const PostUpdateScreen({super.key, required this.post});

//   @override
//   State<PostUpdateScreen> createState() => _PostUpdateScreenState();
// }

// class _PostUpdateScreenState extends State<PostUpdateScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final controller = Get.put(ControllerGetX());
//   final _formKey = GlobalKey<FormState>();
//   List<XFile?> images = [];
//   List<String> currentImages = [];
//   late FirebaseStorage storage;
//   Reference? storageReference;

//   @override
//   void initState() {
//     _titleController.text = widget.post.title;
//     _contentController.text = widget.post.content;
//     currentImages = widget.post.photoUrls ?? [];
//     storage = FirebaseStorage.instance;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _titleController.dispose();
//     _contentController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('게시판 수정'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       "작성일 : ${widget.post.createdAt?.year}.${widget.post.createdAt?.month}.${widget.post.createdAt?.day} ${widget.post.createdAt?.hour}:${widget.post.createdAt?.minute} (${_getWeekday(widget.post.createdAt?.weekday)})",
//                       style: const TextStyle(
//                         fontSize: 12,
//                       ),
//                     ),
//                     widget.post.updatedAt != null
//                         ? Text(
//                             "수정일 : ${widget.post.updatedAt?.year}.${widget.post.updatedAt?.month}.${widget.post.updatedAt?.day} ${widget.post.updatedAt?.hour}:${widget.post.updatedAt?.minute} (${_getWeekday(widget.post.updatedAt?.weekday)})",
//                             style: const TextStyle(
//                               fontSize: 12,
//                             ),
//                           )
//                         : const Text(""),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _titleController,
//                         decoration: const InputDecoration(
//                           labelText: '제목',
//                           hintText: '제목을 입력해 주세요',
//                         ),
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return '제목을 입력해주세요';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       TextFormField(
//                         maxLines: 10,
//                         controller: _contentController,
//                         decoration: const InputDecoration(
//                           labelText: '내용',
//                           hintText: '내용을 입력해주세요',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.multiline,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return '내용을 입력해주세요';
//                           }
//                           return null;
//                         },
//                         onFieldSubmitted: (value) {
//                           _contentController.text = value;
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Align(
//                           alignment: Alignment.topRight,
//                           child: Text("작성자: ${widget.post.authorNickname}"),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Column(
//                         children: [
//                           // Display existing images from widget.post.photoUrls
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children:
//                                   currentImages.asMap().entries.map((entry) {
//                                 return Column(
//                                   children: [
//                                     Container(
//                                       width: 80,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: FileImage(File(entry.value)),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     // Add a button/icon to remove this image
//                                     IconButton(
//                                       icon: Icon(Icons.delete),
//                                       onPressed: () {
//                                         setState(() {
//                                           currentImages.removeAt(entry.key);
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           ),

//                           // Button to add new images
//                           // IconButton(
//                           //   onPressed: () async {
//                           //     final selectedImages = await Navigator.push(
//                           //       context,
//                           //       MaterialPageRoute(
//                           //         builder: (context) => ImagePickerScreen(
//                           //           picker: ImagePicker(),
//                           //           pickedImages:
//                           //         ),
//                           //       ),
//                           //     );

//                           //     if (selectedImages != null) {
//                           //       setState(() {
//                           //         currentImages.addAll(selectedImages);
//                           //       });
//                           //     }
//                           //   },
//                           //   icon: Icon(
//                           //     Icons.camera_alt,
//                           //     size: 35,
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               List<String> imageUrls =
//                                   await uploadImagesToFirebase(currentImages,
//                                       widget.post.documentFileID.toString());

//                               PostModel post = PostModel(
//                                 authorUid: controller.userUid,
//                                 authorNickname:
//                                     controller.userData['nickName'] ?? "",
//                                 isLiked: false,
//                                 likeCount: 0,
//                                 title: _titleController.text,
//                                 content: _contentController.text,
//                                 updatedAt: DateTime.now(),
//                                 createdAt: widget.post.createdAt,
//                                 photoUrls:
//                                     imageUrls.isNotEmpty ? imageUrls : [],
//                                 documentFileID: widget.post.documentFileID,
//                               );

//                               await PostFirebaseService().updatePost(post);

//                               ShowToast('게시물이 성공적으로 수정되었습니다.', 1);
//                               Get.off(const PostScreen());
//                             }
//                           },
//                           child: const Text('수정완료'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String _getWeekday(int? weekday) {
//     if (weekday != null) {
//       switch (weekday) {
//         case 1:
//           return "월요일";
//         case 2:
//           return "화요일";
//         case 3:
//           return "수요일";
//         case 4:
//           return "목요일";
//         case 5:
//           return "금요일";
//         case 6:
//           return "토요일";
//         case 7:
//           return "일요일";
//         default:
//           return "";
//       }
//     } else {
//       return "";
//     }
//   }

//   Future<List<String>> uploadImagesToFirebase(
//       List<String> imageUrls, String documentFileID) async {
//     List<String> updatedImageUrls = [];
//     storageReference = storage.ref().child("postimages/$documentFileID/");

//     for (int index = 0; index < imageUrls.length; index++) {
//       Uint8List imageData = await getImageDataFromUrl(imageUrls[index]);
//       String storagePath = "post_image_$index.jpg";
//       UploadTask uploadTask =
//           storageReference!.child(storagePath).putData(imageData);

//       await uploadTask.whenComplete(() async {
//         String imageUrl =
//             await storageReference!.child(storagePath).getDownloadURL();
//         updatedImageUrls.add(imageUrl);
//       });
//     }

//     return updatedImageUrls;
//   }

//   Future<Uint8List> getImageDataFromUrl(String imageUrl) async {
//     var response = await http.get(Uri.parse(imageUrl));
//     return response.bodyBytes;
//   }
// }
