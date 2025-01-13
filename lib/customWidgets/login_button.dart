import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/main.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/login_view_model.dart';
import 'package:rehuddle/view_models/register_view_model.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  LoginButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final registerView = context.watch<RegisterViewModel>();
    final loginView = context.watch<LoginViewModel>();

    return ElevatedButton(
      onPressed: onPressed,
      child:text.toLowerCase() == 'register'? registerView.isLoading?CircularProgressIndicator(color: kwhiteColor,): Text(
        text,
        style: TextStyle(fontSize: 18.sp),
      ):loginView.isLoading?CircularProgressIndicator(color: kwhiteColor,):Text(
        text,
        style: TextStyle(fontSize: 18.sp),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        backgroundColor: themeColor,
        foregroundColor: kwhiteColor,
      ),
    );
  }
}
