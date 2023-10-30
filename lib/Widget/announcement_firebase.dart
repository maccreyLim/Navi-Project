import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navi_project/model/announcetList_model%20.dart';

class AnnouncementFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _announceListCollection;

  AnnouncementFirebaseService() {
    _announceListCollection = _firestore.collection('announcement');
  }

  Future<void> createAnnouncetList(AnnouncetListModel announcetList) async {
    Map<String, dynamic> AnnouncetListMap =
        announcetList.toMap(); // AnnouncetListMap을 Map으로 변환
    DocumentReference docRef = _announceListCollection.doc(); // 랜덤한 ID 생성
    String documentFileID = docRef.id;

    // set 메서드를 사용하여 데이터 저장
    await docRef.set({
      ...AnnouncetListMap,
      'documentFileID': documentFileID,
    });
  }

  Stream<List<AnnouncetListModel>> readAnnouncetList() {
    return _announceListCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              AnnouncetListModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAnnouncetListQuery() {
    final collection = FirebaseFirestore.instance.collection('announcement');

    // 'createdAt' 필드를 기준으로 내림차순으로 정렬하여 최근 게시물이 위에 오도록 합니다.
    return collection
        .orderBy('createdAt', descending: true)
        .limit(3) // 최근 5개 항목만 가져옵니다.
        .snapshots();
  }

  Future<void> updateAnnouncetList(AnnouncetListModel announcetList) async {
    await _announceListCollection
        .doc(announcetList.documentFileID)
        .update(announcetList.toMap());
  }

  Future<void> deleteAnnouncetList(String? documentFileID) async {
    if (documentFileID != null && documentFileID.isNotEmpty) {
      try {
        await _announceListCollection.doc(documentFileID).delete();
        print("Post with document ID $documentFileID deleted successfully.");
      } catch (e) {
        print("Error deleting post: $e");
        throw e; // 예외 다시 던지기
      }
    } else {
      print("Invalid documentFileID: $documentFileID");
    }
  }
}
