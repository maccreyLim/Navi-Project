import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navi_project/GetX/getx.dart';
import 'package:navi_project/release_calculator_screen/release_model.dart';

class ReleaseFirestore {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final controller = Get.put(ControllerGetX());

//파이어베이스 Create
  Future<String> createRelease(ReleaseModel model) async {
    // 'release' 컬렉션에 대한 참조를 가져옵니다.
    CollectionReference collectionRef =
        db.collection('Users').doc(controller.userUid).collection('release');

    try {
      // 모델 데이터를 컬렉션에 추가하고 문서 참조를 얻습니다.
      DocumentReference docRef = await collectionRef.add(model.toMap());

      // 문서의 'id' 필드를 문서 ID로 업데이트합니다.
      String id = docRef.id;
      await docRef.update({'id': id});

      // 성공 메시지를 반환합니다.
      return '예제 생성이 되었습니다.';
    } catch (e) {
      // 오류를 처리하고 해당 오류를 던집니다.
      print('Example 생성 에러 : $e');
      throw e;
    }
  }

  //파이어베이스 Read
  Future<List<ReleaseModel>> getReleases() async {
    CollectionReference collectionRef =
        db.collection('Users').doc(controller.userUid).collection('release');

    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<ReleaseModel> releases = querySnapshot.docs
          .map(
              (doc) => ReleaseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return releases;
    } catch (e) {
      print('Get Releases Error: $e');
      throw e;
    }
  }

  Stream<List<ReleaseModel>> getReleasesStream() {
    CollectionReference collectionRef =
        db.collection('Users').doc(controller.userUid).collection('release');

    // snapshot을 ReleaseModel로 변환하는 함수
    Stream<List<ReleaseModel>> stream = collectionRef.snapshots().map(
      (querySnapshot) {
        return querySnapshot.docs.map(
          (doc) {
            return ReleaseModel.fromMap(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );

    return stream;
  }

//파이어베이스 Update
  Future<String> updateRelease(ReleaseModel model) async {
    CollectionReference collectionRef =
        db.collection('Users').doc(controller.userUid).collection('release');

    try {
      await collectionRef.doc(model.id).update(model.toMap());
      return '출소 정보가 성공적으로 업데이트되었습니다.';
    } catch (e) {
      print('Update Release Error: $e');
      throw e;
    }
  }

//파이어베이스 Delete
  Future<String> deleteRelease(String releaseId) async {
    CollectionReference collectionRef =
        db.collection('Users').doc(controller.userUid).collection('release');

    try {
      await collectionRef.doc(releaseId).delete();
      return '출소 정보가 성공적으로 삭제되었습니다.';
    } catch (e) {
      print('Delete Release Error: $e');
      throw e;
    }
  }
}
