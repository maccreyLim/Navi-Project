import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String authorUid; //작성자 UID
  final String authorNickname; //작성자 닉네임
  final DateTime? createdAt; //작성날짜
  final DateTime? updatedAt; // 수정날짜
  final String? documentFileID; //문서파일명
  final String title; //제목
  final String content; //내용
  final bool isLiked; //좋아요
  final int likeCount; //좋아요개수
  final List<String>? photoUrls; //사진Url

  PostModel({
    required this.authorUid,
    required this.authorNickname,
    this.createdAt,
    this.updatedAt, // Update the parameter to be nullable
    this.documentFileID,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    this.photoUrls,
  });
  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      authorUid: data['authorUid'],
      authorNickname: data['authorNickname'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      documentFileID: data['documentFileID'],
      title: data['title'],
      content: data['content'],
      isLiked: data['isLiked'],
      likeCount: data['likeCount'],
      photoUrls: List<String>.from(data['photoUrls']),
    );
  }

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
    final documentFileID = data['documentFileID'] as String?;
    final title = data['title'] as String?;
    final content = data['content'] as String?;
    final isLiked = data['isLiked'] as bool?;
    final likeCount = data['likeCount'] as int?;
    final authorNickname = data['authorNickname'] as String? ?? '';

    // photoUrls를 List<dynamic>으로 읽은 다음 String으로 변환
    final photoUrls = (data['photoUrls'] as List<dynamic>?)
        ?.map((url) => url.toString())
        .toList();

    return PostModel(
      authorUid: data['authorUid'] as String? ?? '',
      authorNickname: authorNickname,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? null,
      documentFileID: documentFileID ?? '',
      title: title ?? '',
      content: content ?? '',
      isLiked: isLiked ?? false,
      likeCount: likeCount ?? 0,
      photoUrls: photoUrls ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorUid': authorUid,
      'authorNickname': authorNickname,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'documentFileID': documentFileID,
      'title': title,
      'content': content,
      'isLiked': isLiked,
      'likeCount': likeCount,
      'photoUrls': photoUrls,
    };
  }
}
