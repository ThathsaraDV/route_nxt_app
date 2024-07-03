import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/route/go_router_provider.dart';
import 'package:route_nxt/config/theme/text_theme.dart';
import 'package:route_nxt/config/theme/theme.dart';
import 'package:route_nxt/core/utility/notification_plugin.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/common/presentation/bloc/theme/theme_bloc.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await NotificationPlugin.init();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));

  sl.get<ThemeBloc>().add(const ThemeEvent.getThemeMode());
  final route = sl.get<GoRouterProvider>();
  runApp(RouteNXT(router: route.getRoute(),));
}

class RouteNXT extends StatelessWidget {
  final GoRouter router;

  const RouteNXT({super.key,
    required this.router
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Lato", "Montserrat");
    MaterialTheme theme = MaterialTheme(textTheme);

    return BlocProvider(
      create: (context) => sl<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'RouteNXT',
            routerConfig: router,
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: state,
          );
        },
      ),
    );
  }
}
