import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navi_project/model/post_comment_model.dart';

class PostComentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _postsCollection;

  PostComentFirebaseService() {
    _postsCollection = _firestore.collection('posts');
  }

  Future<void> createComment(PostCommentModel comment, String postId) async {
    Map<String, dynamic> commentMap = comment.toMap(); // CommentModel을 Map으로 변환
    DocumentReference docRef = _postsCollection.doc(postId); // 게시물에 대한 레퍼런스

    // 게시물의 comment 콜렉션에 데이터 저장
    DocumentReference commentDocRef =
        await docRef.collection('comments').add(commentMap);

    // Get the auto-generated document ID
    String documentFileID = commentDocRef.id;
    print('도착 ${documentFileID}');

    // Update the document with the generated ID
    await commentDocRef.update({
      'documentFileID': documentFileID,
    });
  }

  Stream<List<PostCommentModel>> readComments(String postId) {
    DocumentReference docRef = _postsCollection.doc(postId); // 게시물에 대한 레퍼런스

    return docRef.collection('comments').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              PostCommentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateComment(
      PostCommentModel comment, String postId, String commentId) async {
    DocumentReference docRef = _postsCollection.doc(postId); // 게시물에 대한 레퍼런스
    DocumentReference commentRef =
        docRef.collection('comments').doc(commentId); // 코멘트에 대한 레퍼런스

    await commentRef.update(comment.toMap());
  }

  Future<void> deleteComment(String postId, String commentId) async {
    DocumentReference docRef = _postsCollection.doc(postId); // 게시물에 대한 레퍼런스
    DocumentReference commentRef =
        docRef.collection('comments').doc(commentId); // 코멘트에 대한 레퍼런스

    await commentRef.delete();
  }
}
