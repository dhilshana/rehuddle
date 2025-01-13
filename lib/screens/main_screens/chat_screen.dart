import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/customWidgets/chat_tile.dart';
import 'package:rehuddle/services/chat_services.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/chat_screen_view_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String? image;
  final String recieverId;

  ChatScreen(
      {super.key, required this.name, this.image, required this.recieverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  bool isTyping = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatView = context.watch<ChatScreenViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: kwhiteColor,
        titleTextStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leadingWidth: 20.w,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: kBackGroundColor,
              backgroundImage: widget.image != null && widget.image!.isNotEmpty
                  ? NetworkImage(widget.image!)
                  : null,
              child: widget.image == null || widget.image!.isEmpty
                  ? Icon(Icons.person, color: kwhiteColor)
                  : null,
            ),
            SizedBox(width: 10),
            Text(
              widget.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatServices.getMessages(
                senderId: FirebaseAuth.instance.currentUser!.uid,
                recieverId: widget.recieverId,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong. Please try again.'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                } else {
                  final chatDocs = snapshot.data!.docs;
                  final groupedMessages =
                      chatView.groupMessagesByDate(chatDocs, chatView);

                  return ListView.builder(
                    itemCount: groupedMessages.length,
                    padding: EdgeInsets.all(mainPadding),
                    itemBuilder: (context, index) {
                      final group = groupedMessages[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                group['date'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          ...group['messages'].map<Widget>((messageData) {
                            final currentUser =
                                FirebaseAuth.instance.currentUser!.uid;
                            bool isCurrentUser =
                                messageData['senderId'] == currentUser;
                                
                                
                            return ChatTile(
                              mediaUrl: messageData['isMedia']?messageData['message']:null,
                                message: messageData['message'],
                                time: chatView
                                    .formatTime(messageData['timestamp']),
                                isSent: isCurrentUser);
                          }).toList(),
                          StreamBuilder<Map<String, bool>>(
                            stream: chatServices.getTypingStatus(
                                recieverId: widget.recieverId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final typingStatus = snapshot.data!;
                               
                                final isOtherUserTyping =
                                    typingStatus[widget.recieverId] ?? false;

                                if (isOtherUserTyping) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text(
                                      'typing...',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  );
                                }
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          _buildMessageInput(chatView, widget.recieverId),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatScreenViewModel chatView, String recieverId) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        // Icon to pick or capture images
        IconButton(
          icon: Icon(Icons.camera_alt, color: themeColor),
          onPressed: () async {
            // Handle picking or capturing an image
            await chatView.pickImage(recieverId);
          },
        ),
        // Icon to pick files
        IconButton(
          icon: Icon(Icons.attach_file, color: themeColor),
          onPressed: () async {
            // Handle picking a file
            await chatView.pickFile(recieverId);
          },
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            onChanged: (value) {
              final typing = value.isNotEmpty;
              if (isTyping != typing) {
                isTyping = typing;
                chatView.updateTypingStatus(
                    typing: typing, recieverId: recieverId);
              }
            },
            controller: messageController,
            cursorColor: themeColor,
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: themeColor,
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              final messageText = messageController.text.trim();
              if (messageText.isNotEmpty) {
                chatView.sendMessage(
                  recieverId: recieverId,
                  message: messageText,
                );
                messageController.clear();
                if (isTyping) {
                  isTyping = false;
                  chatView.updateTypingStatus(
                    typing: false,
                    recieverId: recieverId,
                  );
                }
              }
            },
          ),
        ),
      ],
    ),
  );
}

}
