import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:route_nxt/config/route/go_router_provider.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/transaction_service.dart';
import 'package:route_nxt/features/common/data/data_sources/user_service.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';
import 'package:route_nxt/features/common/presentation/bloc/theme/theme_bloc.dart';
import 'package:route_nxt/features/dashboard/data/data_sources/local/app_database.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/dashboard/dashboard_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/map/map_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/reminder/reminder_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/transaction/transaction_record_cubit.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/inventory/inventory_cubit.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/new_product/new_product_cubit.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/update_product/update_product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await dotenv.load(fileName: ".env");
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<GoRouterProvider>(GoRouterProvider());
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
  sl.registerSingleton<LocalAuthentication>(LocalAuthentication());
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  sl.registerSingleton<AuthService>(AuthService(sl()));
  sl.registerSingleton<UserService>(UserService(sl()));
  sl.registerSingleton<InventoryService>(InventoryService(sl()));
  sl.registerSingleton<TransactionService>(TransactionService(sl()));

  sl.registerSingleton<ThemeBloc>(
      ThemeBloc(await SharedPreferences.getInstance()));
  sl.registerSingleton<AuthBloc>(AuthBloc(sl(), sl(), sl()));
  sl.registerSingleton<DashboardCubit>(
      DashboardCubit(sl(), await SharedPreferences.getInstance()));
  sl.registerSingleton<ReminderCubit>(
      ReminderCubit(sl.get<AppDatabase>().reminderDao, sl()));
  sl.registerSingleton<MapCubit>(MapCubit(sl(), sl(), sl()));
  sl.registerSingleton<NewProductCubit>(NewProductCubit(sl(), sl()));
  sl.registerSingleton<InventoryCubit>(InventoryCubit(sl(), sl()));
  sl.registerSingleton<UpdateProductCubit>(UpdateProductCubit(sl(), sl()));
  sl.registerSingleton<TransactionRecordCubit>(
      TransactionRecordCubit(sl(), sl(), sl(), sl()));
  sl.registerSingleton<TransactionCubit>(TransactionCubit(sl(), sl()));

  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
}
