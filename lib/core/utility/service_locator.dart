import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_nxt/config/route/go_router_provider.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';
import 'package:route_nxt/features/common/presentation/bloc/theme/theme_bloc.dart';
import 'package:route_nxt/features/dashboard/data/data_sources/local/app_database.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/dashboard/dashboard_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/map/map_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/reminder/reminder_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await dotenv.load(fileName: ".env");
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<GoRouterProvider>(GoRouterProvider());
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<LocalAuthentication>(LocalAuthentication());
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  sl.registerSingleton<AuthService>(AuthService(sl()));

  sl.registerSingleton<ThemeBloc>(
      ThemeBloc(await SharedPreferences.getInstance()));
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl()));
  sl.registerSingleton<DashboardCubit>(
      DashboardCubit(await SharedPreferences.getInstance()));
  sl.registerSingleton<ReminderCubit>(
      ReminderCubit(sl.get<AppDatabase>().reminderDao, sl()));
  sl.registerSingleton<MapCubit>(MapCubit());

  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
}
