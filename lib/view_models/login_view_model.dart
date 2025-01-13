import 'package:flutter/material.dart';
import 'package:rehuddle/screens/main_screens/root_screen.dart';
import 'package:rehuddle/services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  AuthServices authServices = AuthServices();
  // OnesignalServices onesignalServices = OnesignalServices();

  Future<void> loginUiHandler(BuildContext context,
      {required String email, required String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      String result = await authServices.login(email: email, password: password);
      // String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      if (result == 'Login Successful') {
        // onesignalServices.getPlayerIdAndSaveToFirestore(currentUserId);
        // Navigate to RootScreen only on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootScreen()),
        );
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
