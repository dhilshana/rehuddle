import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/customWidgets/email_password_widgets.dart';
import 'package:rehuddle/screens/auth_screens/login_screen.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      final profileView = Provider.of<ProfileViewModel>(context,listen: false);
      // profileView.viewUserDataUiHandler(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
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
        title: Text('My Profile'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),),(route) => false, );
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(mainPadding),
          child: Center(
            child: FutureBuilder(future: profileViewModel.profileUiHandler(), builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: themeColor,),);
              }else if(snapshot.hasError){
                return Center(child: Text('Something went wrong'),);
              }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Center(child: Text('Something went wrong'),);
              }else{
                final userData = snapshot.data;
                return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
              children:[ CircleAvatar(
                radius: 60.r,
                backgroundColor: kBackGroundColor,
                backgroundImage: userData!['profileImageUrl'] != null && userData['profileImageUrl'].isNotEmpty
            ? NetworkImage(userData['profileImageUrl'])
            : null,
        child: userData['profileImageUrl'] == null || userData['profileImageUrl'].isEmpty
            ? Icon(Icons.person, color: Colors.white,size: 50.h,)
            : null,
                
                
              ),
              Positioned(
                bottom: 10.h,
                right: 0.w,
                child: CircleAvatar(
                radius: 15.r,
                backgroundColor: themeColor,
                child: Icon(Icons.edit,size: 15.h,color: kwhiteColor,),
                
              ),
              )
              ]
            ),
            kSizedBoxHeight,
                EmailPasswordWidgets(name: userData['name'],email: userData['email'],),
                kSizedBoxHeight,
                ElevatedButton(
                      onPressed: () {
                        
                        profileViewModel.showProfileEditDialog(context, email: userData['email'], name: userData['name']);
                      },
                      child: Text('Edit',style: TextStyle(
                        fontSize: 18.sp
                      ),),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        backgroundColor: themeColor,
                        foregroundColor: kwhiteColor,
                      ),
                    )
              ],
            );
              }
            },)
          ),
        ),
      )
    );
  }
}