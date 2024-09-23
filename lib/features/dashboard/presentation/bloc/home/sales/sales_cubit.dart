import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/transaction_service.dart';

part 'sales_state.dart';

part 'sales_cubit.freezed.dart';

class SalesCubit extends Cubit<SalesState> {
  final AuthService _authService;
  final TransactionService _transactionService;

  SalesCubit(this._authService, this._transactionService)
      : super(const SalesState.initial());

  Future<void> getNetTotalThisWeek() async {
    try {
      emit(const SalesState.loading());
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        double netTotal =
            await _transactionService.getNetTotalThisWeek(currentUser.uid);
        Map<String, double> barChartData = await _transactionService
            .getNetTotalForEachDayThisWeek(currentUser.uid);
        emit(SalesState.loaded(netTotal, barChartData));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const SalesState.loadingFailed("Internal Server Error"));
    }
  }
}
