import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid; // 고유 식별자
  final String authorUid; // 작성자 Uid
  final String authorNickname; // 작성자 닉네임
  final DateTime createdAt; // 생성일
  final DateTime updatedAt; // 수정일
  final String documentFileName; // 문서 파일명
  final String title; // 제목
  final String content; // 내용
  final bool isLiked; // 좋아요 여부
  final int likeCount; // 좋아요 갯수
  final List<String> photoUrls; // 사진 URL 리스트

  const PostModel({
    required this.uid,
    required this.authorUid,
    required this.authorNickname,
    required this.createdAt,
    required this.updatedAt,
    required this.documentFileName,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    required this.photoUrls, // 추가된 사진 URL 리스트
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
    final documentFileName = data['documentFileName'] as String?;
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
      uid: doc.id,
      authorUid: data['authorUid'] as String? ?? '',
      authorNickname: authorNickname,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      documentFileName: documentFileName ?? '',
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
      'documentFileName': documentFileName,
      'title': title,
      'content': content,
      'isLiked': isLiked,
      'likeCount': likeCount,
      'photoUrls': photoUrls,
    };
  }
}
