_getPhotoLibraryImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      _pickedFile = pickedFile;
    });
    Reference ref = storage.ref('profileImage').child('$_uid.jpg');
    TaskSnapshot uploadTask = await ref.putFile(File(_pickedFile!.path));
    controller.userData['photoUrl'] = await uploadTask.ref.getDownloadURL();
  } else {
    if (kDebugMode) {
      ShowToast('이미지를 선택해주세요', 1);
    }
  }
}
