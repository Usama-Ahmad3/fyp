import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wizmo/main.dart';
import 'package:wizmo/res/app_urls/app_urls.dart';
import 'package:wizmo/res/authentication/authentication.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/res/common_widgets/cashed_image.dart';
import 'package:wizmo/res/common_widgets/text_field_widget.dart';
import 'package:wizmo/utils/flushbar.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/main_bottom_bar/main_bottom_bar.dart';
import 'package:wizmo/view/login_signup/forget_password/forget_password.dart';
import 'package:wizmo/view/login_signup/login/login_provider.dart';
import 'package:wizmo/view/login_signup/signup/signup.dart';
import 'package:wizmo/view/login_signup/widgets/text_data.dart';

class LogIn extends StatefulWidget {
  final LoginProvider provider;
  const LogIn({super.key, required this.provider});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formKey = GlobalKey<FormState>();
  LoginProvider get provider => widget.provider;
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    print('In The Sign In Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                cachedNetworkImage(
                    cuisineImageUrl:
                        'https://tse4.mm.bing.net/th?id=OIP.7jV8fIMTD6_D30jljYWUHgHaEZ&pid=Api&P=0&h=220',
                    height: height * 0.4,
                    imageFit: BoxFit.fill,
                    errorFit: BoxFit.contain,
                    width: width),
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Text(
                    'Sign in to your account',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextData(text: 'Email'),
                Consumer<LoginProvider>(
                  builder: (context, value, child) => TextFieldWidget(
                    controller: emailController,
                    hintText: 'admin@gmail.com',
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
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextData(text: 'Password'),
                Consumer<LoginProvider>(
                  builder: (context, value, child) => TextFieldWidget(
                    controller: passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    suffixIcon: Icons.visibility,
                    hideIcon: Icons.visibility_off,
                    obscure: value.obscure,
                    onTap: () {},
                    passTap: () {
                      value.passHide();
                    },
                    onChanged: (value) {
                      return null;
                    },
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return "password field can't empty";
                      }
                      return null;
                    },
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.034),
                        borderSide: BorderSide(color: AppColors.white)),
                  ),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Consumer<LoginProvider>(
                    builder: (context, value, child) => Center(
                          child: ButtonWidget(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                auth
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then((value) async {
                                  await Authentication().saveLogin(true);
                                  emailController.clear();
                                  passwordController.clear();
                                  if (mounted) {
                                    FlushBarUtils.flushBar(
                                        'Success', context, "Login Successful");
                                    Navigation().pushRep(
                                        MainBottomBar(provider: getIt()),
                                        context);
                                  }
                                }).onError((error, stackTrace) {
                                  FlushBarUtils.flushBar(
                                      error.toString(), context, "Error Catch");
                                });
                              }
                            },
                            text: 'Log in',
                            loading: value.loading,
                          ),
                        )),
                SizedBox(
                  height: height * 0.02,
                ),
                Consumer<LoginProvider>(
                  builder: (context, value, child) => InkWell(
                    onTap: () {
                      Navigation().push(const ForgetPassword(), context);
                    },
                    child: Center(
                        child: Text(
                      'Forget password',
                      style: Theme.of(context).textTheme.headline4,
                    )),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    InkWell(
                      onTap: () {
                        print('Go to SignUp Screen');
                        Navigation().push(SignUp(provider: getIt()), context);
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: AppColors.red),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),

                ///facebook google login Widget
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       vertical: height * 0.02, horizontal: width * 0.2),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       GestureDetector(
                //         onTap: () {},
                //         child: Image.asset(
                //           'assets/images/apple.png',
                //           height: height * .07,
                //           fit: BoxFit.fill,
                //         ),
                //       ),
                //       GestureDetector(
                //         child: Image.asset(
                //           'assets/images/google.png',
                //           height: height * .07,
                //           fit: BoxFit.fill,
                //         ),
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List icon = [Icons.email_outlined, Icons.g_mobiledata_outlined, Icons.apple];
  List text = [
    'Sign in with email',
    'Sign in with google',
    'Sign in with apple',
  ];
  List color = [AppColors.teal, AppColors.blue, AppColors.black];
}
