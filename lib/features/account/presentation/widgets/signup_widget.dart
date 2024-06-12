import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_nxt/config/constants/common_styles.dart';

//ignore: must_be_immutable
class SignUpWidget extends StatefulWidget {
  final TextEditingController controllerFullName;
  final TextEditingController controllerEmail;
  final TextEditingController controllerUsername;
  final TextEditingController controllerPassword;
  final TextEditingController controllerRetypePassword;
  String mobileNumber;
  final Function(String mobileNumber) callback;
  final GlobalKey<FormState> signUpFormKey;

  SignUpWidget(
      {super.key,
      required this.controllerFullName,
      required this.controllerEmail,
      required this.controllerUsername,
      required this.controllerPassword,
      required this.controllerRetypePassword,
      required this.callback,
      required this.mobileNumber,
      required this.signUpFormKey});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          bottom: 20,
          top: 15,
          right: 20,
        ),
        child: Form(
          key: widget.signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Create Your Account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 0.65,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Full Name",
                                ),
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.withOpacity(0.85)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: widget.controllerFullName,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cannot be empty.";
                          }
                          if (value.length < 4) {
                            return 'Minimum length is 4 characters.';
                          }
                          if (value.length > 50) {
                            return 'Maximum length is 20 characters.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                        ],
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'Enter your full name',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      SizedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Email Address",
                                ),
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.withOpacity(0.85)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: widget.controllerEmail,
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
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'example@email.com',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.labelLarge,
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Username",
                            ),
                            TextSpan(
                              text: " *",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.withOpacity(0.85)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: widget.controllerUsername,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cannot be empty.";
                          }
                          if (value.length < 4) {
                            return 'Minimum length is 4 characters.';
                          }
                          if (value.length > 20) {
                            return 'Maximum length is 20 characters.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9_\-.+@]')),
                        ],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'Enter your username',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      //Password
                      SizedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Password",
                                ),
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.withOpacity(0.85)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8)
                                        .withOpacity(0.35)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 14,
                                    // color: AppColor.btnBgColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    isPasswordVisible ? "Hide" : "Show",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      // color: AppColor.btnBgColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: widget.controllerPassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cannot be empty.";
                          }
                          if (value.length < 8) {
                            return 'Minimum length is 8 characters.';
                          }
                          if (value.length > 20) {
                            return 'Maximum length is 20 characters.';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Should have at least one uppercase letter.';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Should have at least one lowercase letter.';
                          }
                          if (!RegExp(r'[!@#$%^&*_]').hasMatch(value)) {
                            return 'Should have at least one special character.';
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Should have at least one numeric character.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9!@#$%^&*_]')),
                        ],
                        obscureText: !isPasswordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: '**********',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      //Confirm Password
                      SizedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Confirm Password",
                                ),
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.withOpacity(0.85)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8)
                                        .withOpacity(0.35)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isConfirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 14,
                                    // color: AppColor.btnBgColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    isConfirmPasswordVisible ? "Hide" : "Show",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      // color: AppColor.btnBgColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: widget.controllerRetypePassword,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !(widget.controllerPassword.value.text
                                      .compareTo(value) ==
                                  0)) {
                            return "Passwords do not match.";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9!@#$%^&*_]')),
                        ],
                        obscureText: !isConfirmPasswordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: '**********',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
