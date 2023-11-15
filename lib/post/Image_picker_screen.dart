import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  final ImagePicker picker;
  final List<XFile?> pickedImages;

  const ImagePickerScreen({
    Key? key,
    required this.picker,
    required this.pickedImages,
  }) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  void getImage(ImageSource source) async {
    final XFile? image = await widget.picker.pickImage(source: source);

    setState(() {
      widget.pickedImages.add(image);
    });
  }

  void getMultiImage() async {
    final List<XFile>? images = await widget.picker.pickMultiImage();

    if (images != null) {
      setState(() {
        widget.pickedImages.addAll(images);
      });
    }
  }

  // 이미지 선택이 완료되면 Navigator를 사용하여 PostCreatScreen으로 되돌아갑니다.
  void navigateToPostCreateScreen(List<XFile?> selectedImages) {
    // 이 부분에서 PostCreatScreen으로 되돌아가며 선택한 이미지 목록을 전달할 수 있습니다.
    Navigator.pop(context, selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the app bar to make it full-screen
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              _imageLoadButtons(),
              const SizedBox(height: 20),
              _gridPhoto(),
              ElevatedButton(
                onPressed: () async {
                  navigateToPostCreateScreen(widget.pickedImages);
                },
                child: const Text('이미지 선택'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageLoadButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: const Text('Image'),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getMultiImage(),
              child: const Text('Multi Image'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridPhoto() {
    return Expanded(
      child: widget.pickedImages.isNotEmpty
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: widget.pickedImages
                  .where((element) => element != null)
                  .map((e) => _gridPhotoItem(e!))
                  .toList(),
            )
          : const SizedBox(),
    );
  }

  Widget _gridPhotoItem(XFile e) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(e.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.pickedImages.remove(e);
                });
              },
              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
