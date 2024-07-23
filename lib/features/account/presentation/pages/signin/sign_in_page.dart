import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/account/presentation/widgets/sign_in_widget.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: sl.get<FirebaseAuth>().authStateChanges(),
        builder: (context, snapshot) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                  initial: () {
                    // if (snapshot.hasData) {
                    //   GoRouter.of(context).go('/home');
                    // }
                  },
                  signInFailure: (message) {
                    CustomSnackBar.showSnackBar(null, message, 'error');
                  },
                  signInSuccess: (user) {
                    GoRouter.of(context).go('/home');
                  },
                  bioAuthSuccess: (bool success) {
                    if (snapshot.hasData) {
                      GoRouter.of(context).go('/home');
                    } else {
                      CustomSnackBar.showSnackBar(null, "Please login again. Session invalid.", 'warning');
                    }
                  },
                  bioAuthFailure: (String message) {
                    CustomSnackBar.showSnackBar(null, message, 'error');
                  },
                  navigate: (String path) {
                    GoRouter.of(context).push(path);
                  },
                  orElse: () {});
            },
            builder: (context, state) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Scaffold(
                  body: state.maybeWhen(
                      initial: () => signInWidget(context),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      signInFailure: (e) => signInWidget(context),
                      signInSuccess: (user) =>
                          const Center(child: CircularProgressIndicator()),
                      bioAuthSuccess: (bool success) {
                        if (snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return signInWidget(context);
                        }
                      },
                      bioAuthFailure: (String message) => signInWidget(context),
                      orElse: () => signInWidget(context)),
                ),
              );
            },
          );
        });
  }

  Widget signInWidget(BuildContext context) {
    return SignInWidget(
        emailController: emailController,
        passwordController: passwordController);
  }
}
