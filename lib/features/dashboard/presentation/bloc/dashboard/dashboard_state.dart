part of 'dashboard_cubit.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;

  const factory DashboardState.stepLoading() = _StepLoading;

  const factory DashboardState.stepLoaded() = _StepLoaded;

  const factory DashboardState.stepLoadingFailed(String message) =
      _StepLoadingFailed;

  const factory DashboardState.loggingOut() = _LoggingOut;

  const factory DashboardState.loggedOut() = _LoggedOut;

  const factory DashboardState.logoutFailed(String message) = _LogoutFailed;

}
