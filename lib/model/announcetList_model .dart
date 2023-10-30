import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncetListModel {
  final String authorUid; // 작성자 UID
  final String authorNickname; // 작성자 닉네임
  final DateTime createdAt; // 생성일
  final DateTime? updatedAt; // 수정일 (make it optional)
  final String title; //제목
  final String content; // 내용
  final bool isLiked; // 좋아요 여부
  final int likeCount; // 좋아요 갯수
  final String? documentFileID;

  AnnouncetListModel({
    required this.authorUid,
    required this.authorNickname,
    required this.createdAt,
    this.updatedAt,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    this.documentFileID,
  });

  factory AnnouncetListModel.fromMap(Map<String, dynamic> data) {
    return AnnouncetListModel(
      authorUid: data['authorUid'] as String? ?? '',
      authorNickname: data['authorNickname'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      title: data['title'],
      content: data['content'],
      isLiked: data['isLiked'],
      likeCount: data['likeCount'],
      documentFileID: data['documentFileID'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorUid': authorUid,
      'authorNickname': authorNickname,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'title': title,
      'content': content,
      'isLiked': isLiked,
      'likeCount': likeCount,
      'documentFileID': documentFileID,
    };
  }
}
