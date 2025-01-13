
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreServices {
  Future<Map<String,dynamic>> storeUserData({required String name,required String password,required String email,String? image,required String uid})async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'name':name,
        'email':email,
        'profileImageUrl':image,
        'recieverId':uid
        
      }); 
      return {'message':'User Registerd Successfully'};   

    }catch(e){
      rethrow;

    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
  final List<Map<String, dynamic>> usersWithLastMessage = [];
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  // Fetch the list of users
  final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

  for (var userDoc in usersSnapshot.docs) {
    final receiverId = userDoc.id;

    // Skip the current user
    if (receiverId == currentUser) continue;

    // Generate ChatRoom ID
    List<String> ids = [currentUser, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Fetch last message
    final chatSnapshot = await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    String lastMessage = 'No messages yet';
    String lastMessageTime = '';
    bool isMedia = false;

    if (chatSnapshot.docs.isNotEmpty) {
      final chatData = chatSnapshot.docs.first.data();
      isMedia = chatData['isMedia']??false;
      lastMessage = chatData['message'] ?? 'No messages yet';
      lastMessageTime = formatTimestamp(chatData['timestamp']);
    }

    usersWithLastMessage.add({
      'name': userDoc['name'],
      'profileImageUrl': userDoc['profileImageUrl'],
      'recieverId': receiverId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isMedia':isMedia,
    });
  }

  return usersWithLastMessage;
}

// Helper to format timestamp
String formatTimestamp(dynamic timestamp) {
  if (timestamp == null) return '';
  
  final dateTime = (timestamp as Timestamp).toDate();
  return DateFormat('h:mm a').format(dateTime); // Example: 1:20 PM
}



  Future<Map<String,dynamic>> getUserDetails()async{
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    try{
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(currentUser).get();
      return userDoc.data() as Map<String,dynamic>;
    }catch(e){
      rethrow;
    }
  }

Future<String> editUserDetails({required String name, required String email}) async {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  try {
    await FirebaseFirestore.instance.collection('Users').doc(currentUser).update({
      'name': name,
      'email': email,
    });
    return "User details updated successfully.";
  } catch (e) {
    print("Error updating user details: $e");
    rethrow;
  }
}

}
