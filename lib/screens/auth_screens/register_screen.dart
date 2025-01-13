import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/customWidgets/login_button.dart';
import 'package:rehuddle/customWidgets/login_text_field.dart';
import 'package:rehuddle/screens/auth_screens/login_screen.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerView = context.watch<RegisterViewModel>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(mainPadding),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Ensure minimum height is screen height
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: kBackGroundColor,
                        backgroundImage: registerView.dpImage != null
                            ? FileImage(registerView.dpImage!) as ImageProvider
                            : null,
                        child: registerView.dpImage == null
                            ? Icon(Icons.person, size: 50, color: kwhiteColor)
                            : null,
                      ),
                      Positioned(
                        bottom: 10.h,
                        right: 0.w,
                        child: GestureDetector(
                          onTap: () {
                            registerView.pickImage();
                          },
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: themeColor,
                            child:
                                Icon(Icons.add, size: 15.h, color: kwhiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  kSizedBoxHeight,
                  LoginTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: const Icon(Icons.person),
                    obscure: false,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  kSizedBoxHeight,
                  LoginTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: const Icon(Icons.email),
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  kSizedBoxHeight,
                  LoginTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: const Icon(Icons.password),
                    obscure: true,
                    suffixIcon: const Icon(Icons.visibility),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Password is required'
                        : null,
                  ),
                  kSizedBoxHeight,
                  LoginTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    icon: const Icon(Icons.password),
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  kSizedBoxHeight,
                  LoginButton(
                    text: 'Register',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform registration logic
                        registerView.registerUiHandler(
                          context,
                          email: _emailController.text,
                          name: _nameController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
                  ),
                  kSizedBoxHeight,
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          text: 'Sign In',
                          style: TextStyle(
                            color: themeColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
