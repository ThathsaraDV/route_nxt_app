import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/user_service.dart';
import 'package:route_nxt/features/common/domain/entity/user_model.dart';

part 'dashboard_state.dart';

part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final UserService _userService;

  DashboardCubit(this._userService) : super(const DashboardState.initial());

  Future<void> getAccountDetails(String uid) async {
    try {
      emit(const DashboardState.stepLoading());
      UserModel user = await _userService.getUser(uid);
      emit(DashboardState.stepLoaded(user));
    } catch (e) {
      emit(const DashboardState.stepLoadingFailed("Internal Server Error"));
    }
  }
}
