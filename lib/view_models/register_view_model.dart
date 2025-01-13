import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rehuddle/screens/main_screens/root_screen.dart';
import 'package:rehuddle/services/auth_services.dart';
import 'package:rehuddle/services/cloudinary_services.dart';
import 'package:rehuddle/services/firestore_services.dart';
import 'package:rehuddle/services/onesignal_services.dart';

class RegisterViewModel extends ChangeNotifier{
  bool isLoading = false;
  File? dpImage;
  String? dpImageUrl = '';
  CloudinaryServices cloudinaryServices = CloudinaryServices(uploadUrl: 'https://api.cloudinary.com/v1_1/dmyj4sdjd/upload', uploadPreset: 'rkdnkpox');
  AuthServices authServices = AuthServices();
  FirestoreServices firestoreServices = FirestoreServices();
  OnesignalServices onesignalServices = OnesignalServices();

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        dpImage = File(pickedFile.path);
        notifyListeners();
        }
  }

  Future<void> registerUiHandler(BuildContext context,{required String name,required String email,required String password})async{
    try{
      isLoading = true;
      notifyListeners();
      final userId = await authServices.register(name: name, password: password, email: email);
      if(dpImage != null){
      dpImageUrl = await cloudinaryServices.uploadProfile(dpImage!);
      }
      notifyListeners();
      final result = await firestoreServices.storeUserData(name: name, password: password, email: email,image: dpImageUrl,uid: userId);
      onesignalServices.getPlayerIdAndSaveToFirestore(userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootScreen(),));

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}