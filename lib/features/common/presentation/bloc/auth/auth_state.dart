part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.signUpSuccess(UserModel user) = _SignUpSuccess;

  const factory AuthState.signUpFailure(String message) = _SignUpFailure;

  const factory AuthState.signInSuccess(UserModel user) = _SignInSuccess;

  const factory AuthState.signInFailure(String message) = _SignInFailure;

  const factory AuthState.bioAuthSuccess(bool success) = _BioAuthSuccess;

  const factory AuthState.bioAuthFailure(String message) = _BioAuthFailure;

  const factory AuthState.logoutSuccess(bool success) = _LogoutSuccess;

  const factory AuthState.logoutFailure(String message) = _LogoutFailure;

  const factory AuthState.navigate(String path) = _Navigate;

}
