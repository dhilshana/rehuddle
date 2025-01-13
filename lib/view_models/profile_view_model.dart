import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rehuddle/services/firestore_services.dart';
import 'package:rehuddle/utils/constants.dart';

class ProfileViewModel extends ChangeNotifier {
  FirestoreServices firestoreServices = FirestoreServices();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void showProfileEditDialog(BuildContext context,
      {required String email, required String name}) async {
        nameController.text = name;
        emailController.text = email;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit your Profle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  
                  labelStyle: TextStyle(
                    color: themeColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: themeColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: themeColor,
                        width: 2.w,
                      )),
                ),
              ),
              kSizedBoxHeight,
              TextField(
                controller:  emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  
                  labelStyle: TextStyle(
                    color: themeColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: themeColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: themeColor,
                        width: 2.w,
                      )),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                editUser(context, name: nameController.text, email: emailController.text);
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18.sp, color: themeColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 18.sp, color: themeColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> profileUiHandler() async {
    try {
      final user = await firestoreServices.getUserDetails();
      return user;
    } catch (e) {
      return {'message': 'Somethig went wrong'};
    }
  }

  void editUser(BuildContext context,
      {required String name, required String email}) async {
    try {
      final result =
          await firestoreServices.editUserDetails(name: name, email: email);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {}
  }
}
