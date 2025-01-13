import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rehuddle/services/auth_services.dart';
import 'package:rehuddle/services/chat_services.dart';
import 'package:rehuddle/services/cloudinary_services.dart';

class ChatScreenViewModel extends ChangeNotifier{
   final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();
  final CloudinaryServices cloudinaryServices = CloudinaryServices(uploadUrl: 'https://api.cloudinary.com/v1_1/dmyj4sdjd/upload', uploadPreset:'chatmedia');

  Future<void> pickFile(String recieverId) async {
  // Use FilePicker to select a file
  final result = await FilePicker.platform.pickFiles();
  if (result != null) {
    final file = File(result.files.single.path!);
    // Upload the file and send its URL
    final fileUrl = await cloudinaryServices.uploadFile(file);
    sendMessage(recieverId: recieverId, message: fileUrl, isMedia: true);
  }
}


Future<void> pickImage(String recieverId) async {
  // Use ImagePicker or similar library to pick/capture an image
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    // Upload the image and send its URL
    final imageUrl = await cloudinaryServices.uploadFile(File(pickedImage.path));
    sendMessage(recieverId: recieverId, message: imageUrl, isMedia: true);
  }
}


  void sendMessage({required String recieverId, required String message, bool isMedia = false}) async{
    await chatServices.sendMessage(recieverId: recieverId, message: message,isMedia: isMedia);
  }

  

  String formatTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('hh:mm a').format(dateTime); // Example: '9:30 AM'
}

/// Formats the date as 'Today', 'Yesterday', or 'Month Day' (e.g., 'January 1').
String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));

  if (dateTime.isAfter(today)) {
    return 'Today';
  } else if (dateTime.isAfter(yesterday)) {
    return 'Yesterday';
  } else {
    return DateFormat('MMMM d').format(dateTime); // Example: 'January 1'
  }
}

List<Map<String, dynamic>> groupMessagesByDate(
      List<QueryDocumentSnapshot> chatDocs, ChatScreenViewModel chatView) {
    final groupedMessages = <Map<String, dynamic>>[];
    String? currentGroupDate;
    Map<String, dynamic>? currentGroup;

    for (final doc in chatDocs) {
      final messageData = doc.data() as Map<String, dynamic>;
      final formattedDate = chatView.formatDate(messageData['timestamp']);

      if (currentGroupDate == null || currentGroupDate != formattedDate) {
        if (currentGroup != null) {
          groupedMessages.add(currentGroup);
        }

        currentGroupDate = formattedDate;
        currentGroup = {'date': formattedDate, 'messages': []};
      }

      currentGroup!['messages'].add(messageData);
    }

    if (currentGroup != null) {
      groupedMessages.add(currentGroup);
    }

    return groupedMessages;
  }

  void updateTypingStatus({required bool typing,required String recieverId}) {
    chatServices.updateTypingStatus(
      recieverId: recieverId,
      isTyping: typing,
    );
  }
}