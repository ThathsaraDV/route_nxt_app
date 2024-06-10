part of 'sign_in_cubit.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState.initial() = _Initial;

  const factory SignInState.initialLogin() = _Initiallogin;

  const factory SignInState.loading() = _Loading;

  const factory SignInState.error(String message) = _Error;

  const factory SignInState.success(SignInStatus signInStatus) = _Success;

  const factory SignInState.signUp() = _SignUp;

  const factory SignInState.alreadyLoggedIn() = _AlreadyLoggedIn;
}
