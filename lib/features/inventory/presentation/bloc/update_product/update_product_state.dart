part of 'update_product_cubit.dart';

@freezed
abstract class UpdateProductState with _$UpdateProductState {
  const factory UpdateProductState.initial() = _Initial;

  const factory UpdateProductState.loading() = _Loading;

  const factory UpdateProductState.loaded(ProductModel product) = _Loaded;

  const factory UpdateProductState.loadingFailed(String message) =
  _LoadingFailed;

  const factory UpdateProductState.saving() = _Saving;

  const factory UpdateProductState.saved(ProductModel product) = _Saved;

  const factory UpdateProductState.savingFailed(String message) =
  _SavingFailed;

}
