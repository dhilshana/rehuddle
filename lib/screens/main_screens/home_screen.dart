import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/customWidgets/chat_card.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
  final homeView = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: kwhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 25.sp,

          fontWeight: FontWeight.w600,
          letterSpacing: 2
        ),
        title: Text('ReHuddle'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: mainPadding),
        child: FutureBuilder(
          future:homeView.getUsers(), 
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){

              return Center(child: CircularProgressIndicator(color: themeColor,),);
            }else if(snapshot.hasError){

              return Center(child: Text(snapshot.error.toString()),);
            }else{

              return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
              final user = snapshot.data![index];
              

            return ChatCard(
               name: user['name'],
                  lastMsg: user['lastMessage'] ?? 'No messages yet',
                  time: user['lastMessageTime'] ?? '',
                  imageUrl: user['profileImageUrl'],
                  recieverId: user['recieverId'],
                  isMedia: user['isMedia'],
              
            );
          },
        );
            }
          },
          )
      ),
    );
  }
}