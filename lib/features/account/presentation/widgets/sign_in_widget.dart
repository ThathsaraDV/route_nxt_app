import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/account/presentation/bloc/signin/sign_in_cubit.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  late bool isErrorUsername = false;
  late bool isErrorPassword = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _signInWidget(context),
    );
  }

  Widget? _signInWidget(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        _signInAppBar(),
        SizedBox(
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 20,
                top: 0,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  TextFormField(
                    controller: widget.usernameController,
                    style: isErrorUsername
                        ? const TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.w500)
                        : const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                    onChanged: (value) {
                      bool isAllowedChar =
                          RegExp(r"^[a-zA-Z0-9_\-.@+]+$").hasMatch(value);
                      setState(() {
                        isErrorUsername = !isAllowedChar;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 22,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 15, bottom: 10, top: 14, right: 15),
                      hintText: "Username",
                      hintStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  TextFormField(
                    controller: widget.passwordController,
                    obscureText: !isPasswordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: isErrorPassword
                        ? const TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.w500)
                        : const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                    onChanged: (value) {
                      bool isAllowedChar =
                          RegExp(r"[a-zA-Z0-9!@#$%^&*()_]").hasMatch(value);
                      setState(() {
                        isErrorPassword = !isAllowedChar;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 20,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 14,
                            // color: isDarkMode ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 15, bottom: 10, top: 14, right: 15),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  const Text(
                    "Please enter your username and password or use the biometric authentication to sign in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      letterSpacing: 0.85,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // if (widget.usernameController.value.text.isNotEmpty &&
                        //     widget.passwordController.value.text.isNotEmpty) {
                        //   context.read<SignInCubit>().signIn(
                        //       username: widget.usernameController.value.text,
                        //       password: widget.passwordController.value.text);
                        // } else {
                        //   CustomSnackBar.showSnackBar(
                        //       null, "Invalid username or password", 'error');
                        // }
                        GoRouter.of(context).pushReplacement('/home');
                      },
                      style: CommonStyles.mainButtonStyles(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(
                        'Sign In'.toUpperCase(),
                        style: CommonStyles.mainButtonTextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      style: const ButtonStyle(alignment: Alignment.center),
                      onPressed: () {
                        context.read<SignInCubit>().init();
                        context.read<SignInCubit>().bioMetricAuth();
                      },
                      icon: const Icon(Icons.fingerprint_outlined, size: 42),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to RouteNXT?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.5,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 0.5,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<SignInCubit>().navigateToSignUp();
                        },
                        child: const Text(
                          "SIGN UP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            letterSpacing: 1,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  )),
                ],
              )),
        ),
      ],
    );
  }

  _signInAppBar() {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.325,
      // width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Image.asset(
                  (isDarkMode)
                      ? 'asset/images/logo_dark_mode.png'
                      : 'asset/images/logo.png',
                  height: screenHeight * 0.08,
                  fit: BoxFit.fill),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenHeight * 0.085,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.surfaceTint,
                                width: 0.6)),
                      ),
                    ),
                    Text(
                      "sign in".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          letterSpacing: 2),
                    ),
                    SizedBox(
                      width: screenHeight * 0.085,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.surfaceTint,
                                width: 0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "Log in to continue your journey",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    letterSpacing: 1),
              ),
            ]),
      ),
    );
  }
}
