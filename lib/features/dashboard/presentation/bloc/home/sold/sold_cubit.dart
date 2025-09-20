import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/transaction_service.dart';
import 'package:route_nxt/features/dashboard/data/models/product_sold_model.dart';

part 'sold_state.dart';

part 'sold_cubit.freezed.dart';

class SoldCubit extends Cubit<SoldState> {
  final AuthService _authService;
  final TransactionService _transactionService;

  SoldCubit(this._authService, this._transactionService)
      : super(const SoldState.initial());

  Future<void> getProductsSoldThisWeek() async {
    try {
      emit(const SoldState.loading());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        List<ProductSoldModel> list =
            await _transactionService.getProductsSoldThisWeek(currentUser.uid);
        emit(SoldState.loaded(list));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const SoldState.loadingFailed("Internal Server Error"));
    }
  }
}
