part of 'sign_up_cubit.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;

  const factory SignUpState.signingUp() = _SigningUp;

  const factory SignUpState.loading() = _Loading;

  const factory SignUpState.error(String message) =_Error;

  const factory SignUpState.success(SignUpStatus signUpStatus) = _Success;

}