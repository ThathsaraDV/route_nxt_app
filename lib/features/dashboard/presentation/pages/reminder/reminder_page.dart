import 'package:flutter/material.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/reminder/new_reminder.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/reminder/reminder_history.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({
    super.key,
  });

  @override
  State<ReminderPage> createState() => _ReminderPage();
}

class _ReminderPage extends State<ReminderPage> {
  final _accountCardController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: SizedBox(
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withOpacity(0.1),
                        spreadRadius: 6,
                        blurRadius: 14,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 4, right: 4),
                  // height: data.size.height * 0.45,
                  child: PageView(
                    controller: _accountCardController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int index) {},
                    children: const [ReminderHistory(), NewReminder()],
                  )),
              Positioned(
                bottom: -6,
                child: SmoothPageIndicator(
                  controller: _accountCardController,
                  count: 2,
                  effect: WormEffect(
                      spacing: 8.0,
                      radius: 10,
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor:
                          Theme.of(context).colorScheme.primaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
