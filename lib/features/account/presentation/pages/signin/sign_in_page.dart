import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/features/account/presentation/bloc/signin/sign_in_cubit.dart';
import 'package:route_nxt/features/account/presentation/widgets/sign_in_widget.dart';
import 'package:route_nxt/features/common/presentation/pages/splash_screen.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignInCubit>().init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        state.maybeWhen(
            error: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            success: (message) {
              GoRouter.of(context).push('/home');
            },
            alreadyLoggedIn: () {
              GoRouter.of(context).push('/home');
            },
            signUp: () {
              GoRouter.of(context).push('/signup');
            },
            orElse: () {});
      },
      builder: (context, state) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            body: state.when(
              signUp: () => signInWidget(context),
              alreadyLoggedIn: () => signInWidget(context),
              initial: () => const SplashScreen(),
              initialLogin: () => signInWidget(context),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e) => signInWidget(context),
              success: (newNumber) {
                return signInWidget(context);
              },
            ),
            // bottomNavigationBar: _bottomNavBar()
          ),);
      },
    );
  }

  Widget signInWidget(BuildContext context) {
    return SignInWidget(
        usernameController: usernameController,
        passwordController: passwordController);
  }

}
