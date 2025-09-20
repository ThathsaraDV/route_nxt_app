part of 'sales_cubit.dart';

@freezed
class SalesState with _$SalesState {
  const factory SalesState.initial() = _Initial;

  const factory SalesState.loading() = _Loading;

  const factory SalesState.loaded(
      double netTotal, Map<String, double> barChartData) = _Loaded;

  const factory SalesState.loadingFailed(String message) = _LoadingFailed;
}
