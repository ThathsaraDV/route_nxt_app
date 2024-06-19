import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboard_state.dart';

part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final SharedPreferences _sharedPreferences;

  DashboardCubit(this._sharedPreferences)
      : super(const DashboardState.initial());

  Future<void> getAccountDetails() async {
    try {
      emit(const DashboardState.stepLoading());

      emit(const DashboardState.stepLoaded());
    } on DioException catch (e) {
      emit(const DashboardState.stepLoadingFailed("Internal Server Error"));
    }
  }

  Future<void> logout() async {
    try {
      emit(const DashboardState.loggingOut());

      emit(const DashboardState.loggedOut());
    } on DioException catch (e) {
      emit(const DashboardState.logoutFailed("Internal Server Error"));
    }
  }

}
