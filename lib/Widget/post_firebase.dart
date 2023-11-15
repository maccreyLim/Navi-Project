import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/model/post_model.dart';

class PostFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsCollection;

  PostFirebaseService() {
    _postsCollection = _firestore.collection('posts');
  }
  Future<void> createPost(PostModel post, String documentFileID) async {
    Map<String, dynamic> postMap = post.toMap();

    // 원하는 documentFileID를 사용하여 문서를 생성
    DocumentReference docRef = _postsCollection.doc(documentFileID);

    // set 메서드를 사용하여 데이터 저장
    await docRef.set(postMap);
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
        // 1. 해당 문서(doc) 안에 있는 모든 하위 컬렉션(subcollection)의 문서 삭제
        final postRef = _postsCollection.doc(documentFileID);
        final commentsRef = postRef.collection('comments');

        // 모든 댓글(comment) 문서 삭제
        await commentsRef.get().then((querySnapshot) {
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });

        // 2. 해당 문서(doc) 삭제
        await postRef.delete();
        // 3. 이미지 파일을 삭제
        await deleteImages(documentFileID);

        ShowToast('해당 게시물이 삭제되었습니다.', 1);
      } catch (e) {
        print("Error deleting post: $e");
        throw e; // 예외 다시 던지기
      }
    } else {
      print("Invalid documentFileID: $documentFileID");
    }
  }

  Future<void> deleteImages(String documentFileID) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final storageReference = storage.ref().child("postimages/$documentFileID");

    try {
      // 해당 경로의 모든 파일 삭제
      await storageReference.listAll().then((result) {
        for (final item in result.items) {
          item.delete();
        }
      });
    } catch (e) {
      print("Error deleting images: $e");
      throw e; // 예외 다시 던지기
    }
  }
}
