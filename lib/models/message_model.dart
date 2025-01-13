import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final String message;
  final Timestamp timestamp;
  bool isMedia;

  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.recieverId,
    required this.message,
    required this.timestamp,
    required this.isMedia,
  });

  //convert message to map
  Map<String,dynamic> toMap(){
    return {
      'senderId':senderId,
      'senderEmail':senderEmail,
      'recieverId':recieverId,
      'message':message,
      'timestamp':timestamp,
      'isMedia':isMedia,
    };
  }
}