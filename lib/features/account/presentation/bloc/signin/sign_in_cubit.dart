import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_nxt/core/enums/signin_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  final LocalAuthentication auth;
  final SharedPreferences sharedPreferences;

  SignInCubit(this.auth, this.sharedPreferences)
      : super(const SignInState.initial());

  Future<void> init() async {
    if (state == const SignInState.initial()) {
      checkIfSessionValid();
    } else {
      emit(const SignInState.initialLogin());
    }
  }

  Future<void> signIn(
      {required String username, required String password}) async {
    try {
      emit(const SignInState.initialLogin());
      emit(const SignInState.loading());
      emit(const SignInState.success(SignInStatus.success));
    } catch (e) {
      emit(const SignInState.error("System Error"));
    }
  }

  Future<void> bioMetricAuth() async {
    try {
      var deviceSupported = await auth.isDeviceSupported();
      if (!deviceSupported) {
        emit(const SignInState.error("Device Not Supported"));
      } else {
        bool authenticated = await auth.authenticate(
          localizedReason: "Subscribe or you will never find any answer",
          options: const AuthenticationOptions(
              stickyAuth: false, biometricOnly: false),
        );
        if (authenticated) {
          bool isRefreshed = true;
          if (isRefreshed) {
            emit(const SignInState.success(SignInStatus.success));
          } else {
            emit(const SignInState.error("Please login. Session invalid."));
          }
        } else {
          emit(const SignInState.error("Try again"));
        }
      }
    } on PlatformException catch (e) {
      emit(const SignInState.error("Device Not Supported"));
    }
  }

  Future<void> serviceAccountAuth() async {
    try {
      emit(const SignInState.loading());

      emit(const SignInState.signUp());
    } catch (e) {
      emit(const SignInState.error("System Error"));
    }
  }

  Future<void> checkIfSessionValid() async {
    try {
      emit(const SignInState.initial());
      emit(const SignInState.loading());
      bool isLogged = false;
      if (isLogged) {
        emit(const SignInState.alreadyLoggedIn());
      } else {
        emit(const SignInState.initialLogin());
      }
    } catch (e) {
      emit(const SignInState.error("System Error"));
    }
  }
}
