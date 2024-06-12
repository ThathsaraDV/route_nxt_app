import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/account/presentation/bloc/signup/sign_up_cubit.dart';
import 'package:route_nxt/features/account/presentation/widgets/signup_widget.dart';
import 'package:route_nxt/features/common/presentation/pages/splash_screen.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerRetypePassword =
      TextEditingController();
  String mobileNumber = '';
  final signUpFormKey = GlobalKey<FormState>();
  bool isContinueDisabled = false;

  @override
  void initState() {
    super.initState();
    context.read<SignUpCubit>().init();
  }

  @override
  void dispose() {
    super.dispose();
    controllerFullName.dispose();
    controllerEmail.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        state.maybeWhen(
            error: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            success: (message) {
              GoRouter.of(context).go('/login');
            },
            orElse: () {});
      },
      builder: (context, state) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: Container(
                decoration: BoxDecoration(
                  // gradient: isDarkMode ? AppColor.darkCardGradient : AppColor.lightCardGradient,
                ),
                  child: Scaffold(
                    // backgroundColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.35),
                      appBar: AppBar(
                        // backgroundColor: isDarkMode
                        //     ? AppColor.darkColor_3
                        //     : AppColor.shadingColor_3,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_rounded,
                              // color: isDarkMode
                              //     ? AppColor.mainColor
                              //     : AppColor.btnTxtColor
                          ),
                          iconSize: 18,
                          onPressed: () {
                            GoRouter.of(context).go('/login');
                          },
                        ),
                        title: Text(
                          "SIGN UP",
                          style: TextStyle(
                              fontSize: 26,
                              // letterSpacing: 1.5,
                              // wordSpacing: 4,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700),
                        ),
                        centerTitle: true,
                      ),
                      body: state.when(
                        initial: () => const SplashScreen(),
                        signingUp: () => signUpWidget(context),
                        loading: () =>
                        const Center(child: CircularProgressIndicator()),
                        error: (e) => signUpWidget(context),
                        success: (newNumber) {
                          return signUpWidget(context);
                        },
                      ),
                      bottomNavigationBar: _bottomNavBar()))
        );
      },
    );
  }

  void onDataReceived(String mobileNumber) {
    setState(() {
      this.mobileNumber = mobileNumber;
    });
  }

  Widget signUpWidget(BuildContext context) {
    return SignUpWidget(
        controllerFullName: controllerFullName,
        controllerEmail: controllerEmail,
        controllerUsername: controllerUsername,
        controllerPassword: controllerPassword,
        controllerRetypePassword: controllerRetypePassword,
        mobileNumber: mobileNumber,
        signUpFormKey: signUpFormKey,
        callback: onDataReceived);
  }

  _bottomNavBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: isContinueDisabled ? null : () {
          if (signUpFormKey.currentState!.validate()) {
            context.read<SignUpCubit>().signUp(
                mobileNumber: mobileNumber,
                username: controllerUsername.value.text,
                email: controllerEmail.value.text,
                password: controllerPassword.value.text
            );
          }
        },
        style: CommonStyles.mainButtonStyles(),
        child: Text('Sign Up'.toUpperCase(),
            style: CommonStyles.mainButtonTextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }

}
