part of 'inventory_cubit.dart';

@freezed
abstract class InventoryState with _$InventoryState {
  const factory InventoryState.initial() = _Initial;

  const factory InventoryState.loading() = _Loading;

  const factory InventoryState.loaded(List<ProductModel> productList) = _Loaded;

  const factory InventoryState.loadingFailed(String message) =
  _LoadingFailed;

}
