import 'package:cloud_firestore/cloud_firestore.dart';

import 'modle.dart';

class FirebaseFirestoreExample {
  FirebaseFirestore db = FirebaseFirestore.instance;

//파이어베이스 Create
  Future<String> createExample(Model modle) async {
    CollectionReference collectionRef = db.collection('exmple');
    try {
      DocumentReference docRef = await collectionRef.add(modle.toMap());
      // Firestore 문서 내에 ID 필드를 업데이트
      String id = docRef.id;
      await docRef.update({'id': id});
      return '예제 생성이 되었습니다.';
    } catch (e) {
      print('Example 생성 에러 : $e');
      throw e;
    }
  }

  //파이어베이스 Read
}
