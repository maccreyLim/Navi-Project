import 'package:cloud_firestore/cloud_firestore.dart';

class PostCommentModel {
  final String authorUid; // 작성자 UID
  final String authorNickname; // 작성자 닉네임
  final DateTime createdAt; // 생성일
  final DateTime? updatedAt; // 수정일 (make it optional)
  final String content; // 내용
  final bool isLiked; // 좋아요 여부
  final int likeCount; // 좋아요 갯수
  final String? documentFileID;
  final String photoUrl;

  PostCommentModel({
    required this.authorUid,
    required this.authorNickname,
    required this.createdAt,
    this.updatedAt,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    this.documentFileID,
    required this.photoUrl,
  });

  factory PostCommentModel.fromMap(Map<String, dynamic> data) {
    return PostCommentModel(
      authorUid: data['authorUid'] as String? ?? '',
      authorNickname: data['authorNickname'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      content: data['content'],
      isLiked: data['isLiked'],
      likeCount: data['likeCount'],
      documentFileID: data['documentFileID'] as String,
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  factory PostCommentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostCommentModel(
      authorUid: data['authorUid'] as String? ?? '',
      authorNickname: data['authorNickname'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      content: data['content'],
      isLiked: data['isLiked'],
      likeCount: data['likeCount'],
      documentFileID: data['documentFileID'] as String,
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorUid': authorUid,
      'authorNickname': authorNickname,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'content': content,
      'isLiked': isLiked,
      'likeCount': likeCount,
      'documentFileID': documentFileID,
      'photoUrl': photoUrl,
    };
  }
}
