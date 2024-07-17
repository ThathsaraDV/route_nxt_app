import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/global/app_settings.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/account/presentation/pages/signin/sign_in_page.dart';
import 'package:route_nxt/features/account/presentation/pages/signup/sign_up_page.dart';
import 'package:route_nxt/features/common/presentation/bloc/auth/auth_bloc.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/dashboard/dashboard_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/map/map_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/reminder/reminder_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:route_nxt/features/dashboard/presentation/pages/home/home_page.dart';
import 'package:route_nxt/features/dashboard/presentation/pages/map/map_page.dart';
import 'package:route_nxt/features/dashboard/presentation/pages/reminder/reminder_page.dart';

class GoRouterProvider {
  GoRouter getRoute() {
    return GoRouter(
      navigatorKey: AppSettings.rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthBloc>.value(
                      value: sl<AuthBloc>(),
                    ),
                  ],
                  child: const SignInPage(),
                )),
        GoRoute(
            path: '/signup',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                fullscreenDialog: true,
                key: state.pageKey,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthBloc>.value(
                      value: sl<AuthBloc>(),
                    ),
                  ],
                  child: const SignUpPage(),
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            }),
        StatefulShellRoute.indexedStack(
          pageBuilder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return CustomTransitionPage(
              fullscreenDialog: true,
              key: state.pageKey,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(
                    value: sl<AuthBloc>(),
                  ),
                  BlocProvider<DashboardCubit>.value(
                    value: sl<DashboardCubit>(),
                  )
                ],
                child: DashboardPage(navigationShell: navigationShell),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return Container(child: child);
              },
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/home',
                  builder: (BuildContext context, GoRouterState state) =>
                      const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/reminder',
                  builder: (BuildContext context, GoRouterState state) =>
                      BlocProvider<ReminderCubit>.value(
                    value: sl<ReminderCubit>(),
                    child: const ReminderPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/map',
                  builder: (BuildContext context, GoRouterState state) =>
                  BlocProvider<MapCubit>.value(
                    value: sl<MapCubit>(),
                    child: const MapPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
