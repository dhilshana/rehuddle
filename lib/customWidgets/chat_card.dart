import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehuddle/screens/main_screens/chat_screen.dart';
import 'package:rehuddle/utils/constants.dart';

class ChatCard extends StatelessWidget {
  String name;
  String lastMsg;
  String time;
  String? imageUrl;
  String recieverId;
  bool isMedia;
  ChatCard({super.key,required this.name,required this.lastMsg,required this.time,this.imageUrl,required this.recieverId,required this.isMedia});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name,style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500
      ),),
      subtitle:isMedia?Align(
        alignment: Alignment.bottomLeft,
        child: Icon(Icons.file_open,color: Colors.grey,size: 15,)): Text(lastMsg,style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400
      ),),
      leading: CircleAvatar(
         backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Icon(Icons.person, color: Colors.white,size: 35.h,)
            : null,
            backgroundColor: kBackGroundColor,
            radius: 25.r,
      ),
      trailing: Text(time),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(name: name, recieverId: recieverId,image: imageUrl,),));
      },
      splashColor: kBackGroundColor,
    );
  }
}