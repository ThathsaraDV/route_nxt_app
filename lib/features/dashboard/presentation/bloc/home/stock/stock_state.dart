part of 'stock_cubit.dart';

@freezed
abstract class StockState with _$StockState {
  const factory StockState.initial() = _Initial;

  const factory StockState.loading() = _Loading;

  const factory StockState.loaded(List<ProductModel> productList) = _Loaded;

  const factory StockState.loadingFailed(String message) =
  _LoadingFailed;

}
