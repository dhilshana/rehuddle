import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class OnesignalServices {
  void getPlayerIdAndSaveToFirestore(String userId) async {
 

  // Get the Player ID
  // var deviceState = await OneSignal.shared.getDeviceState();
  String? playerId = await OneSignal.User.pushSubscription.id;

  if (playerId != null) {

    // Save the Player ID to Firestore under the user's document
    FirebaseFirestore.instance
        .collection('Users') // Your Firestore collection
        .doc(userId) // Document ID for the logged-in user
        .set({'playerId': playerId}, SetOptions(merge: true));

  } else {
    print("Failed to get Player ID");
  }
}

void sendNotification({required String senderName, required String recieverPlayerId,required String message})async{
  try{
    var url = Uri.parse("https://onesignal.com/api/v1/notifications");
     var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic os_v2_app_txqefjuk3reudfaax7llbz44lvtdzel7rdye2qntw65y6rlnm57e3mscyjfkuwvm23tezcvjr7wqzvnmkpirhh3prpmwxf3wdc4gplq"
      },
      body: jsonEncode({
        "app_id": "9de042a6-8adc-4941-9400-bfd6b0e79c5d",
        "include_player_ids": [recieverPlayerId,],
        "headings": {"en": senderName},
        "contents": {"en": message},
      }),
    );
    
    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }catch(e){
    print("Player ID not found for the receiver");
  }

}


}