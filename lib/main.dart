import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_nxt/config/route/go_router_provider.dart';
import 'package:route_nxt/config/theme/text_theme.dart';
import 'package:route_nxt/config/theme/theme.dart';
import 'package:route_nxt/core/utility/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RouteNXT',
      routerConfig: router,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
