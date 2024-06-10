import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_nxt/config/route/go_router_provider.dart';
import 'package:route_nxt/features/account/presentation/bloc/signin/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<GoRouterProvider>(GoRouterProvider());
  sl.registerSingleton<LocalAuthentication>(LocalAuthentication());

  sl.registerSingleton<SignInCubit>(SignInCubit(sl(),  await SharedPreferences.getInstance()));

  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
}
