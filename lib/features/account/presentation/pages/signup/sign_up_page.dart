import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/account/presentation/widgets/signup_widget.dart';
import 'package:route_nxt/features/common/domain/entity/user_model.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController controllerFullName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerRetypePassword =
      TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  bool isContinueDisabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerFullName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: sl.get<FirebaseAuth>().authStateChanges(),
        builder: (context, snapshot) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                  signUpFailure: (message) {
                    CustomSnackBar.showSnackBar(null, message, 'error');
                  },
                  signUpSuccess: (message) {
                    GoRouter.of(context).go('/login');
                  },
                  orElse: () {});
            },
            builder: (context, state) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                  data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: Scaffold(
                      appBar: AppBar(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 24,
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
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700),
                        ),
                        centerTitle: true,
                      ),
                      body: state.maybeWhen(
                          initial: () => signUpWidget(context),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          signUpSuccess: (e) => signUpWidget(context),
                          signUpFailure: (message) {
                            return signUpWidget(context);
                          },
                          orElse: () => signUpWidget(context)),
                      bottomNavigationBar: _bottomNavBar()));
            },
          );
        });
  }

  Widget signUpWidget(BuildContext context) {
    return SignUpWidget(
        controllerFullName: controllerFullName,
        controllerEmail: controllerEmail,
        controllerPassword: controllerPassword,
        controllerRetypePassword: controllerRetypePassword,
        signUpFormKey: signUpFormKey);
  }

  _bottomNavBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: isContinueDisabled
            ? null
            : () {
                if (signUpFormKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(AuthEvent.signUp(UserModel(
                      id: '',
                      email: controllerEmail.value.text,
                      password: controllerPassword.value.text,
                      displayName: controllerFullName.value.text)));
                }
              },
        style: CommonStyles.mainButtonStyles(),
        child: Text('Sign Up'.toUpperCase(),
            style: CommonStyles.mainButtonTextStyle(
                color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }
}
