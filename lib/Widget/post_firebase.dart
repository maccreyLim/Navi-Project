import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navi_project/model/post_model.dart';

class PostFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsCollection;

  PostFirebaseService() {
    _postsCollection = _firestore.collection('posts');
  }

  Future<void> createPost(PostModel post) async {
    Map<String, dynamic> postMap = post.toMap(); // PostModel을 Map으로 변환
    DocumentReference docRef = _postsCollection.doc(); // 랜덤한 ID 생성
    String documentFileID = docRef.id;

    // set 메서드를 사용하여 데이터 저장
    await docRef.set({
      ...postMap,
      'documentFileID': documentFileID,
    });
  }

  Stream<List<PostModel>> readPosts() {
    return _postsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updatePost(PostModel post) async {
    await _postsCollection.doc(post.documentFileID).update(post.toMap());
  }

  Future<void> deletePost(String? documentFileID) async {
    if (documentFileID != null && documentFileID.isNotEmpty) {
      try {
        await _postsCollection.doc(documentFileID).delete();
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
