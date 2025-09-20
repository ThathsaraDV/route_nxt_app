import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/dashboard/data/data_sources/remote/distance_service.dart';

part 'distance_state.dart';

part 'distance_cubit.freezed.dart';

class DistanceCubit extends Cubit<DistanceState> {
  final AuthService _authService;
  final DistanceService _distanceService;

  DistanceCubit(this._authService, this._distanceService)
      : super(const DistanceState.initial());

  Future<void> getDistanceThisWeek() async {
    try {
      emit(const DistanceState.loading());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        double distance =
            await _distanceService.getDistanceThisWeek(currentUser.uid);
        emit(DistanceState.loaded(distance));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const DistanceState.loadingFailed("Internal Server Error"));
    }
  }
}
