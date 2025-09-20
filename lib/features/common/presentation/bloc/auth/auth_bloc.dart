import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/user_service.dart';
import 'package:route_nxt/features/common/domain/entity/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final UserService userService;
  final LocalAuthentication auth;
  StreamSubscription<User?>? _firebaseStreamEvents;

  AuthBloc(this.authService, this.auth, this.userService)
      : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(signIn: (String email, String password) async {
        try {
          emit(const AuthState.loading());
          await authService.logInWithEmailAndPassword(
              email: email, password: password);
          _firebaseStreamEvents =
              authService.getUserStream().listen((User? user) {
            if (null != user) {
              sl.get<AuthBloc>().add(AuthEvent.afterSignIn(
                  UserModel.withEmailAndPassword(
                      email: email, password: password)));
            } else {
              sl.get<AuthBloc>().add(AuthEvent.afterSignIn(
                  UserModel.withEmailAndPassword(
                      email: email, password: password)));
            }
          });
        } on FirebaseAuthException catch (e) {
          emit(AuthState.signInFailure(e.message ?? "Internal Server Error"));
        } catch (e) {
          emit(const AuthState.signInFailure('Internal Server Error'));
        }
      }, bioAuth: () async {
        try {
          emit(const AuthState.loading());
          var deviceSupported = await auth.isDeviceSupported();
          if (!deviceSupported) {
            emit(const AuthState.bioAuthFailure("Device Not Supported"));
          } else {
            bool authenticated = await auth.authenticate(
              localizedReason: "Subscribe or you will never find any answer",
              options: const AuthenticationOptions(
                  stickyAuth: false, biometricOnly: false),
            );
            if (authenticated) {
              bool isRefreshed = true;
              var currentUser = authService.getCurrentUser();
              if (isRefreshed && null != currentUser) {
                emit(AuthState.bioAuthSuccess(isRefreshed));
              } else {
                emit(const AuthState.bioAuthFailure(
                    "Session Expired. Please login with username and password"));
              }
            } else {
              emit(const AuthState.bioAuthFailure("Try again"));
            }
          }
        } on PlatformException catch (e) {
          emit(const AuthState.bioAuthFailure("Device Not Supported"));
        }
      }, signUp: (UserModel user) async {
        try {
          emit(const AuthState.loading());
          var userModel =
              await authService.signUpUser(user.email!, user.password!);
          userModel.displayName = user.displayName;
          userService.addUser(userModel);
          emit(AuthState.signUpSuccess(user));
        } on FirebaseAuthException catch (e) {
          emit(AuthState.signUpFailure(e.message ?? "Internal Server Error"));
        } catch (e) {
          emit(const AuthState.signUpFailure('Internal Server Error'));
        }
      }, logout: () async {
        emit(const AuthState.loading());
        await authService.signOutUser();
        await _firebaseStreamEvents?.cancel();
        _firebaseStreamEvents = null;
        emit(const AuthState.logoutSuccess(true));
      }, navigateTo: (String path) {
        emit(const AuthState.loading());
        emit(AuthState.navigate(path));
      }, afterSignIn: (UserModel user) async {
        await _firebaseStreamEvents?.cancel();
        _firebaseStreamEvents = null;
        emit(AuthState.signInSuccess(user));
      });
    });
  }

  User getCurrentUser() {
    var currentUser = authService.getCurrentUser();
    if (null != currentUser) {
      return currentUser;
    } else {
      throw Exception("Internal Server Error");
    }
  }
}
