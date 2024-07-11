part of 'map_cubit.dart';

@freezed
abstract class MapState with _$MapState {
  const factory MapState.initial() = _Initial;

  const factory MapState.loading() = _Loading;

  const factory MapState.loaded(LocationData currLocation, Location location) =
      _Loaded;

  const factory MapState.loadingFailed(String message) = _LoadingFailed;
}
