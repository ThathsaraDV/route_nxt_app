part of 'sold_cubit.dart';

@freezed
abstract class SoldState with _$SoldState {
  const factory SoldState.initial() = _Initial;

  const factory SoldState.loading() = _Loading;

  const factory SoldState.loaded(List<ProductSoldModel> soldList) = _Loaded;

  const factory SoldState.loadingFailed(String message) = _LoadingFailed;
}
