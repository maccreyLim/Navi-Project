import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navi_project/Widget/show_toast.dart';
import 'package:navi_project/message/message_model.dart';

class MassageFirebase {
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

//Create
  Future<String> createMessage(Message message, String nickname) async {
    try {
      final docRef = await messagesCollection.add(message.toMap());
      print(docRef);

      String id = docRef.id;

      // Firestore 문서 내에 ID 필드를 업데이트
      await docRef.update({'id': id});
      ShowToast('${nickname}에게 메시지를 보냈습니다.', 1);

      return id;
    } catch (e) {
      print('메시지 생성 중 오류: $e');
      throw e;
    }
  }

  //Read
  Future<List<Message>> getMessages(String receiverUid) async {
    try {
      final querySnapshot = await messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Message.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    }
  }

// Stream Read(실시간)
  Stream<List<Message>> getMessagesStream(String receiverUid) {
    try {
      CollectionReference messagesCollection =
          FirebaseFirestore.instance.collection('messages');
      return messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) =>
                Message.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      // 오류가 발생한 경우 오류를 출력하고 빈 Stream을 반환
      print('메시지 가져오기 오류: $e');
      return Stream.value([]);
    }
  }

//Update
  Future<void> updateMessage(Message message) async {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(message.id).update(message.toMap());
    } catch (e) {
      print('메시지 업데이트 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    }
  }

//Delete
  Future<void> deleteMessage(String messageId) async {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(messageId).delete();
    } catch (e) {
      print('메시지 삭제 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    }
  }

//상대방을 닉네임로 검색
  Future<Map<String, Map<String, dynamic>>> getUserByNickname(
      String partialNickname) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    try {
      final querySnapshot = await usersCollection
          .where('nickName', isGreaterThanOrEqualTo: partialNickname)
          .where('nickName', isLessThan: partialNickname + 'z')
          .get();

      final userData = <String, Map<String, dynamic>>{};

      for (final document in querySnapshot.docs) {
        final userDataFromDoc = document.data() as Map<String, dynamic>;
        final uid = userDataFromDoc['uid'];
        final nickname = userDataFromDoc['nickName'];
        final occupation = userDataFromDoc['occupation'];
        final workspace = userDataFromDoc['workspace'];
        final photoUrl = userDataFromDoc['photoUrl'];
        final parters = userDataFromDoc['parters'];

        if (uid != null && nickname != null) {
          userData[uid] = {
            'nickname': nickname,
            'photoUrl': photoUrl,
            'uid': uid,
            'occupation': occupation,
            'workspace': workspace,
            'parters': parters,
          };
        }
      }

      return userData;
    } catch (e) {
      print('사용자 검색 중 오류 발생: $e');
      return {}; // 예외 발생 시 빈 맵 반환
    }
  }
}
