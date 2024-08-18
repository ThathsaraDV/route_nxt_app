import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

part 'update_product_state.dart';

part 'update_product_cubit.freezed.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final InventoryService _inventoryService;
  final AuthService _authService;

  UpdateProductCubit(this._inventoryService, this._authService)
      : super(const UpdateProductState.initial());

  Future<void> getProduct(String productId) async {
    try {
      emit(const UpdateProductState.loading());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        ProductModel product =
            await _inventoryService.getProductById(productId, currentUser.uid);
        await Future.delayed(const Duration(seconds: 1));
        emit(UpdateProductState.loaded(product));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const UpdateProductState.loadingFailed("Internal Server Error"));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      emit(const UpdateProductState.saving());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        product.uid = currentUser.uid;
        await _inventoryService.updateProduct(product);
        await Future.delayed(const Duration(seconds: 1));
        emit(UpdateProductState.saved(product));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const UpdateProductState.savingFailed("Internal Server Error"));
    }
  }
}
