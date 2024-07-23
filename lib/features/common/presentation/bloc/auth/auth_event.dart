part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signIn(String email, String password) = _SignIn;

  const factory AuthEvent.bioAuth() = _BioAuth;

  const factory AuthEvent.signUp(UserModel user) = _SignUp;

  const factory AuthEvent.logout() = _Logout;

  const factory AuthEvent.navigateTo(String path) = _NavigateTo;

  const factory AuthEvent.afterSignIn(UserModel user) = _AfterSignIn;
}
