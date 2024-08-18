part of 'new_product_cubit.dart';

@freezed
abstract class NewProductState with _$NewProductState {
  const factory NewProductState.initial() = _Initial;

  const factory NewProductState.saving() = _Saving;

  const factory NewProductState.saved(ProductModel product) = _Saved;

  const factory NewProductState.savingFailed(String message) =
  _SavingFailed;

}
