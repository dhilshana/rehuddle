import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<String> register({
    required String name,
    required String password,
    required String email,
    File? image,
  }) async {
    try {
      // Register the user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve and return the current user's UID
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      return uid;
    } catch (e) {
      rethrow;
    }
  }
  Future<String> login({ required String email,required String password})async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return 'Login Successful';
    }on FirebaseAuthException catch (e) {
    // FirebaseAuthException provides specific error messages
    return e.message ?? 'An unknown error occurred';
  } catch (e) {
    // Handle any other types of exceptions
    return 'An error occurred: $e';
  }
  }
}
