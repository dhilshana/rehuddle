import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/customWidgets/login_text_field.dart';
import 'package:rehuddle/screens/auth_screens/register_screen.dart';
import 'package:rehuddle/customWidgets/login_button.dart';
import 'package:rehuddle/utils/constants.dart';
import 'package:rehuddle/view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginView = context.watch<LoginViewModel>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(mainPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginTextField(
                label: 'Email',
                icon: const Icon(Icons.person),
                obscure: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              kSizedBoxHeight,
              LoginTextField(
                label: 'Password',
                icon: const Icon(Icons.password),
                obscure: true,
                suffixIcon: const Icon(Icons.visibility),
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              kSizedBoxHeight,
              LoginButton(
  text: 'Login',
  onPressed: () {
    if (_formKey.currentState!.validate()) {
     loginView.loginUiHandler(context, email: _emailController.text, password: _passwordController.text);
    }
  },
),

              kSizedBoxHeight,
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                      text: 'Sign Up',
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
    );
  }
}
