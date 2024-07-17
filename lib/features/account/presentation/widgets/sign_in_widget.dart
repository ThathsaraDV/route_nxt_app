import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final signInFormKey = GlobalKey<FormState>();
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
              child: Form(
                key: signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    TextFormField(
                      controller: widget.emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        if (!RegExp(
                                r"^(?![._-])(?!.*[._-]{2})[a-zA-Z0-9]+(?:[._-][a-zA-Z0-9]+)*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Invalid email format.';
                        }
                        if (value.length > 254) {
                          return 'Maximum length is 254 characters.';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9_\-.@]')),
                      ],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_rounded,
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
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    TextFormField(
                      controller: widget.passwordController,
                      obscureText: !isPasswordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        if (!RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*_]).{8,20}$')
                            .hasMatch(value)) {
                          return 'Invalid password format.';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9!@#$%^&*_]')),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 20,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          if (signInFormKey.currentState!.validate()) {
                            sl.get<AuthBloc>().add(AuthEvent.signIn(
                                widget.emailController.value.text,
                                widget.passwordController.value.text));
                          }
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
                          sl.get<AuthBloc>().add(const AuthEvent.bioAuth());
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
                            sl
                                .get<AuthBloc>()
                                .add(const AuthEvent.navigateTo('/signup'));
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
                ),
              )),
        ),
      ],
    );
  }

  _signInAppBar() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.325,
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
