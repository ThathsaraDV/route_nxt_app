import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

part 'stock_state.dart';

part 'stock_cubit.freezed.dart';

class StockCubit extends Cubit<StockState> {
  final AuthService _authService;
  final InventoryService _inventoryService;

  StockCubit(this._authService, this._inventoryService)
      : super(const StockState.initial());

  Future<void> getLowStockProducts() async {
    try {
      emit(const StockState.loading());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        List<ProductModel> list =
            await _inventoryService.getLowStockProducts(currentUser.uid);
        emit(StockState.loaded(list));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const StockState.loadingFailed("Internal Server Error"));
    }
  }
}
