import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/dashboard/data/models/reminder_model.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/reminder/reminder_cubit.dart';

class NewReminder extends StatefulWidget {
  const NewReminder({super.key});

  @override
  State<NewReminder> createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerBody = TextEditingController();
  final TextEditingController controllerScheduledDate = TextEditingController();
  final GlobalKey<FormState> reminderFormKey = GlobalKey<FormState>();
  DateTime? scheduledDate;

  @override
  void initState() {
    super.initState();
  }

  void saveReminder() {
    if (reminderFormKey.currentState!.validate()) {
      context.read<ReminderCubit>().saveReminder(
          ReminderModel(
              null,
              controllerTitle.text.trim(),
              controllerBody.text.trim(),
              'payload',
              controllerScheduledDate.text),
          scheduledDate!);
    }
  }

  void clearFields() {
    controllerTitle.clear();
    controllerBody.clear();
    controllerScheduledDate.clear();
    scheduledDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderCubit, ReminderState>(
      listener: (context, state) {
        state.maybeWhen(
            savingReminderFailed: (String message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            savedReminder: (ReminderModel reminder) => clearFields(),
            orElse: () {});
      },
      builder: (context, state) {
        return state.maybeWhen(
            initial: () => const Center(child: CircularProgressIndicator()),
            savingReminder: () =>
                const Center(child: CircularProgressIndicator()),
            savedReminder: (ReminderModel reminder) {
              return getReminderCard(context);
            },
            savingReminderFailed: (String message) {
              return getReminderCard(context);
            },
            orElse: () => getReminderCard(context));
      },
    );
  }

  Widget getReminderCard(BuildContext context) {
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
                    Icons.alarm_add_rounded,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text("Add Reminders",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Form(
                key: reminderFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controllerTitle,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Must be at least 4 characters.";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                          LengthLimitingTextInputFormatter(30)
                        ],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                              fontWeight: FontWeight.w500),
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controllerBody,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Must be at least 4 characters.";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9,./\-\s]')),
                          LengthLimitingTextInputFormatter(150)
                        ],
                        keyboardType: TextInputType.text,
                        maxLines: 8,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'Content',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                              fontWeight: FontWeight.w500),
                        ),
                        style: const TextStyle(fontSize: 16),
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please select the schedule date.";
                          }
                          return null;
                        },
                        controller: controllerScheduledDate,
                        readOnly: true,
                        onTap: () async {
                          scheduledDate = await showOmniDateTimePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3652),
                            ),
                            is24HourMode: false,
                            isShowSeconds: false,
                            minutesInterval: 1,
                            secondsInterval: 1,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            constraints: const BoxConstraints(
                              maxWidth: 350,
                              maxHeight: 775,
                            ),
                            transitionBuilder: (context, anim1, anim2, child) {
                              return FadeTransition(
                                opacity: anim1.drive(
                                  Tween(
                                    begin: 0,
                                    end: 1,
                                  ),
                                ),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 200),
                            barrierDismissible: true,
                          );

                          if (scheduledDate != null) {
                            if (!scheduledDate!.isBefore(DateTime.now())) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd h:mm a')
                                      .format(scheduledDate!);
                              setState(() {
                                controllerScheduledDate.text = formattedDate;
                              });
                            } else {
                              CustomSnackBar.showSnackBar(null,
                                  'Please select a future date time', 'warning');
                            }
                          }
                        },
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          enabledBorder: CommonStyles.buildSharedInputBorder(),
                          focusedBorder: CommonStyles.buildFocusedInputBorder(),
                          border: CommonStyles.buildSharedInputBorder(),
                          hintText: 'Select Date',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                              fontWeight: FontWeight.w500),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 72),
                      ElevatedButton(
                        style: CommonStyles.secondaryButtonStyles(
                            minimumSizeWidth: 240, minimumSizeHeight: 42),
                        onPressed: saveReminder,
                        child: Text('save'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerBody.dispose();
    controllerScheduledDate.dispose();
    super.dispose();
  }
}
