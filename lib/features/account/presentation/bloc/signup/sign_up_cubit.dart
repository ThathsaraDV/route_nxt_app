import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/core/enums/signup_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_up_state.dart';

part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SharedPreferences _sharedPreferences;

  SignUpCubit(this._sharedPreferences)
      : super(const SignUpState.initial());

  Future<void> init() async {
    emit(const SignUpState.signingUp());
  }

  Future<void> signUp(
      {required String mobileNumber,
      required String email,
      required String username,
      required String password}) async {
    try {
      emit(const SignUpState.loading());

      emit(const SignUpState.success(SignUpStatus.success));

    } catch (e) {
      print('Error: ${e.toString()}');
      emit(const SignUpState.error("System Error"));
    }
  }

}
