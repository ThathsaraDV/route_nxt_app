part of 'distance_cubit.dart';

@freezed
abstract class DistanceState with _$DistanceState {
  const factory DistanceState.initial() = _Initial;

  const factory DistanceState.loading() = _Loading;

  const factory DistanceState.loaded(double distance) = _Loaded;

  const factory DistanceState.loadingFailed(String message) =
  _LoadingFailed;

}
