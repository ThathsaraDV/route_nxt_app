import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

part 'inventory_state.dart';

part 'inventory_cubit.freezed.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryService _inventoryService;
  final AuthService _authService;

  InventoryCubit(this._inventoryService, this._authService)
      : super(const InventoryState.initial());

  Future<void> getAllProducts() async {
    try {
      emit(const InventoryState.loading());
      var currentUser = _authService.getCurrentUser();
      List<ProductModel> productList = [];
      if (null != currentUser) {
        productList = await _inventoryService.getAllProducts(currentUser.uid);
        emit(InventoryState.loaded(productList));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const InventoryState.loadingFailed("Internal Server Error"));
    }
  }
}
