import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/common/presentation/widgets/empty_widget.dart';
import 'package:route_nxt/features/dashboard/data/models/reminder_model.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/reminder/reminder_cubit.dart';

class ReminderHistory extends StatefulWidget {
  const ReminderHistory({super.key});

  @override
  State<ReminderHistory> createState() => _ReminderHistoryState();
}

class _ReminderHistoryState extends State<ReminderHistory> {
  List<ReminderModel> reminderList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderCubit>().getAllReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderCubit, ReminderState>(
      listener: (context, state) {
        state.maybeWhen(
            historyLoadingFailed: (String message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            deletingReminderFailed: (String message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            deletedReminder: (int id) =>
                context.read<ReminderCubit>().getAllReminders(),
            orElse: () {});
      },
      builder: (context, state) {
        return state.maybeWhen(
            initial: () => const Center(child: CircularProgressIndicator()),
            historyLoading: () =>
                const Center(child: CircularProgressIndicator()),
            historyLoaded: (List<ReminderModel> reminderList) {
              return getReminderList(context, reminderList);
            },
            historyLoadingFailed: (String message) {
              return getEmptyList(context);
            },
            emptyHistoryLoaded: (List<ReminderModel> reminderList) {
              return getEmptyList(context);
            },
            deletingReminder: () =>
                const Center(child: CircularProgressIndicator()),
            deletedReminder: (int id) =>
                const Center(child: CircularProgressIndicator()),
            deletingReminderFailed: (String message) {
              return getReminderList(context, reminderList);
            },
            orElse: () => const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget getReminderList(
      BuildContext context, List<ReminderModel> reminderList) {
    reminderList = reminderList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 6,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4, left: 10, right: 20, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.alarm_rounded,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text("Reminders",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(reminderList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  reminderList[index].title ?? "N/A",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  reminderList[index].scheduledDate ?? "N/A",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reminderList[index].body ?? "N/A",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.8)),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => context
                                  .read<ReminderCubit>()
                                  .deleteReminder(reminderList[index].id!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        )
      ],
    );
  }

  Widget getEmptyList(BuildContext context) {
    return const EmptyWidget(
      icon: Icons.alarm_off_rounded,
      title: 'No Reminders',
    );
  }
}
