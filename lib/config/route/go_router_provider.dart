import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/global/app_settings.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/account/presentation/bloc/signin/sign_in_cubit.dart';
import 'package:route_nxt/features/account/presentation/pages/signin/sign_in_page.dart';

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
                    BlocProvider<SignInCubit>.value(
                      value: sl<SignInCubit>(),
                    )
                  ],
                  child: const SignInPage(),
                )),
      ],
    );
  }
}
