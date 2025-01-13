import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehuddle/models/message_model.dart';
import 'package:rehuddle/services/onesignal_services.dart';

class ChatServices {

  OnesignalServices onesignalServices = OnesignalServices();

  Future<void> sendMessage(
      {required String recieverId, required String message,required isMedia}) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
     var userDoc = await FirebaseFirestore.instance.collection('Users').doc(recieverId).get();
  String? playerId = userDoc.data()?['playerId'];
  var senderDoc = await FirebaseFirestore.instance.collection('Users').doc(currentUserId).get();
  String senderName = senderDoc.data()?['name'];



    try {
      MessageModel newMessage = MessageModel(
          senderId: currentUserId,
          senderEmail: currentUserEmail,
          recieverId: recieverId,
          message: message,
          timestamp: timestamp,
          isMedia: isMedia);
      //construct chat room ids for the two users
      List<String> ids = [currentUserId, recieverId];
      ids.sort();

      String chatRoomId = ids.join('_');

      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
          if(isMedia == false){
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .update(
        {'typing': FieldValue.delete()},
      );
          }

      onesignalServices.sendNotification(senderName: senderName, recieverPlayerId: playerId??'', message: message);
      
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTypingStatus({
    required String recieverId,
    required bool isTyping,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<String> ids = [currentUserId, recieverId];
    ids.sort();

    String chatRoomId = ids.join('_');
    try {
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .set({
        'typing': {
          currentUserId: isTyping,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Stream<Map<String, bool>> getTypingStatus({required String recieverId}) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<String> ids = [currentUserId, recieverId];
    ids.sort();

    String chatRoomId = ids.join('_');
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        return (data['typing'] as Map<String, dynamic>).cast<String, bool>();
      }
      return {};
    });
  }

  Stream<QuerySnapshot> getMessages(
      {required String senderId, required String recieverId}) {
    List<String> ids = [senderId, recieverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
