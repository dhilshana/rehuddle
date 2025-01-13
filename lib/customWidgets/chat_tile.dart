import 'package:flutter/material.dart';
import 'package:rehuddle/screens/main_screens/full_screen_media_viewer.dart';
import 'package:rehuddle/utils/constants.dart';

class ChatTile extends StatelessWidget {
  final String? message;
  final String? mediaUrl;
  final String time;
  final bool isSent; // True if the message is sent by the user

  ChatTile({
    super.key,
    this.message,
    this.mediaUrl,
    required this.time,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: isSent?EdgeInsets.fromLTRB(40, 5, 10, 5):EdgeInsets.fromLTRB(10, 5, 40, 5),
        decoration: BoxDecoration(
          color: isSent ? themeColor : kGreyColor, // Sent vs Received colors
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: isSent ? Radius.circular(10) : Radius.zero,
            bottomRight: isSent ? Radius.zero : Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            mediaUrl != null
            ? GestureDetector(
                onTap: () {
                  // Open media in full screen or download
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenMediaViewer(url: mediaUrl!),
                    ),
                  );
                },
                child: Image.network(
                  mediaUrl!,
                  fit: BoxFit.cover,
                  width: 200, // Adjust size as needed
                  height: 200,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50),
                ),
              ):
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: isSent ?kwhiteColor :kBlackColor ,
              ),
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: isSent ? kwhiteColor : kBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
