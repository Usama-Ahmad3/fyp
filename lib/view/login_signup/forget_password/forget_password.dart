import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/res/colors/app_colors.dart';
import 'package:maintenance/res/common_widgets/button_widget.dart';
import 'package:maintenance/res/common_widgets/text_field_widget.dart';
import 'package:maintenance/utils/flushbar.dart';
import 'package:maintenance/utils/navigator_class.dart';
import 'package:maintenance/view/login_signup/login/login.dart';
import 'package:maintenance/view/login_signup/signup/signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Forget Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .08,
              ),
              Text(
                'Enter Your Email',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08, vertical: height * 0.01),
                child: Text(
                  'Enter Your Registered Email To Reset Your Password',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                height: height * .1,
              ),
              TextFieldWidget(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.person,
                onTap: () {},
                onChanged: (value) {
                  return null;
                },
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "email field can't empty";
                  }
                  return null;
                },
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              ButtonWidget(
                text: 'Send',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  await _auth
                      .sendPasswordResetEmail(email: emailController.text)
                      .then((value) async {
                    FlushBarUtils.flushBar(
                        "Password reset email has been sent to ${emailController.text}. Please check your inbox.",
                        context,
                        "Send Successfully");
                    setState(() {
                      loading = false;
                    });
                  });
                },
                loading: loading,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  GestureDetector(
                      onTap: () {
                        navigateToSignup(context);
                      },
                      child: Text(
                        "Signup",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.red),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateToSignup(context) {
    Navigation().pushRep(const SignUp(), context);
  }

  navigateToLogin(BuildContext context) {
    Navigation().pushRep(const LogIn(), context);
  }
}
