import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/presentation/pages/splash_screen.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/dashboard/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  bool isSideMenuOpen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().getAccountDetails();
    });
  }

  void toggleSideMenu() {
    setState(() {
      isSideMenuOpen = !isSideMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = 64.0;
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.maybeWhen(
            stepLoadingFailed: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            loggedOut: () {
              GoRouter.of(context).pushReplacement('/login');
            },
            logoutFailed: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
              GoRouter.of(context).pushReplacement('/login');
            },
            stepLoaded: () {},
            orElse: () {});
      },
      builder: (context, state) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
            data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(appBarHeight),
                    child: AppBar(
                      iconTheme: IconThemeData(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      actions: <Widget>[
                        badges.Badge(
                          badgeContent: Text(
                            '10',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 8),
                          ),
                          position: badges.BadgePosition.topEnd(top: 6, end: 8),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: CommonStyles.errorMsgBgColor,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.person,
                          ),
                          onPressed: () {},
                        )
                      ],
                    )),
                body: state.maybeWhen(
                    initial: () => const SplashScreen(),
                    stepLoading: () =>
                        const Center(child: CircularProgressIndicator()),
                    stepLoaded: () {
                      return widget.navigationShell;
                    },
                    stepLoadingFailed: (e) =>
                        const Center(child: CircularProgressIndicator()),
                    loggingOut: () =>
                        const Center(child: CircularProgressIndicator()),
                    loggedOut: () =>
                        const Center(child: CircularProgressIndicator()),
                    logoutFailed: (message) =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () {
                      return widget.navigationShell;
                    }),
                drawer: drawer(state),
                bottomNavigationBar: state.maybeWhen(
                    loggingOut: () => const SizedBox.shrink(),
                    orElse: () {
                      return bottomNavBar();
                    })));
      },
    );
  }

  Widget drawer(DashboardState state) {
    return Container(
      decoration: BoxDecoration(
        gradient: CommonStyles.lightCardGradient1,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 68,
                          width: 68,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                child: Center(
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text('thathsara',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(
                          height: 2,
                        ),
                        Text('thathsaradananjaya@gmail.com',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            state.maybeWhen(
                loggingOut: () => Center(
                      child: Transform.scale(
                        scale: 1,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                orElse: () {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 10, right: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                        },
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.9),
                        selected: true,
                        tileColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.9),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 4.5,
                          ),
                          child: const Icon(
                            Icons.inventory_2_rounded,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Inventory',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: AppColor.shadingColor_3,
                          ),
                        ),
                        onTap: () {
                          // GoRouter.of(context).go('/inventory');
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36,
                          padding: const EdgeInsets.only(
                              left: 10, right: 6, top: 8, bottom: 8),
                          child: const Icon(
                            Icons.payments_rounded,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: AppColor.shadingColor_3,
                          ),
                        ),
                        onTap: () {
                          // GoRouter.of(context).go('/transactions');
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36,
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: const Icon(
                            Icons.shelves,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: AppColor.shadingColor_3,
                          ),
                        ),
                        onTap: () {
                          // GoRouter.of(context).go('/products');
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 10, right: 6),
                          child: const Icon(
                            Icons.logout,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: AppColor.shadingColor_3,
                          ),
                        ),
                        onTap: () async {
                          // context.read<DashboardCubit>().logout();
                        },
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget bottomNavBar() {
    final MediaQueryData data = MediaQuery.of(context);
    return SnakeNavigationBar.color(
      behaviour: SnakeBarBehaviour.floating,
      snakeShape: SnakeShape.indicator,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 20,
      padding: const EdgeInsets.all(10),
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      snakeViewColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      shadowColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.12),
      height: data.size.height * 0.08,
      currentIndex: widget.navigationShell.currentIndex,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.payments_rounded), label: 'Transactions'),
        BottomNavigationBarItem(
            icon: Icon(Icons.near_me_rounded), label: 'Navigate'),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
