import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

part 'new_product_state.dart';

part 'new_product_cubit.freezed.dart';

class NewProductCubit extends Cubit<NewProductState> {
  final InventoryService _inventoryService;
  final AuthService _authService;

  NewProductCubit(this._inventoryService, this._authService)
      : super(const NewProductState.initial());

  Future<void> addProduct(ProductModel product) async {
    try {
      emit(const NewProductState.saving());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        product.uid = currentUser.uid;
        await _inventoryService.addProduct(product);
        await Future.delayed(const Duration(seconds: 1));
        emit(NewProductState.saved(product));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const NewProductState.savingFailed("Internal Server Error"));
    }
  }
}
