import 'package:app_settings/app_settings.dart';
import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/models/widgets/LabelsList.dart';
import 'package:to_do_list/models/widgets/TimePicker.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:popover/popover.dart';

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  late TextEditingController _title_controller;
  late TextEditingController _note_controller;
  String? title;
  TimeOfDay reminder1 = TimeOfDay.now();
  DateTime reminder2 = DateTime.now();
  @override
  void initState() {
    super.initState();
    _title_controller = TextEditingController();
    _note_controller = TextEditingController();
    Future.delayed(
      Duration(milliseconds: 500),
      () {},
    );
    MainData.flag = "";
  }

  @override
  void dispose() {
    _title_controller.dispose();
    _note_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 140),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 300,
          minHeight: 200,
          maxWidth: 600,
          maxHeight: 800,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: 4, top: 4),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => {
                          MainData.flag = "",
                          context.pop(),
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: (value) => setState(
                  () {
                    title = value;
                  },
                ),
                controller: _title_controller,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 21,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 23,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 20,
                      bottom: 3,
                      top: 0,
                      right: 20),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
              TextFormField(
                controller: _note_controller,
                style: const TextStyle(
                  fontSize: 17,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w400),
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 26, top: 2, right: 40),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Description',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  top: 4,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(MainData.saved)

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          onTap: () {
                            setState(() {
                              MainData.saved = false;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Text(
                                "${reminder1.hour.toString().padLeft(2, "0")}:${reminder1.minute.toString().padLeft(2, "0")}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed,
                                  fontSize: 16, fontWeight: Device.menuFont),
                            ),
                          ),
                        ),
                      ),
                    if (MainData.flag.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          onTap: () {
                            setState(() {
                              MainData.flag = "";
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Text(
                              MainData.flag,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed, fontWeight: Device.menuFont,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: TextButton(
                        onPressed: () async {
                          if (await isAlarmAllowed()) {
                            if (context.mounted) {
                              reminder1 = await selectTime(context, "");
                            }
                            reminder2 = DateTime(
                              reminder2.year,
                              reminder2.month,
                              reminder2.day,
                              reminder1.hour,
                              reminder1.minute,
                            );
                            if(MainData.saved){
                              setState(() {
                                MainData.saved=true;
                              });
                            }
                          } else {
                            if (context.mounted) {
                              await allowAlarm(context);
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_alarm_rounded,
                              size: 18,
                            ),
                            Text(
                              ' Reminder',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Builder(builder: (context) {
                        return TextButton(
                          onPressed: () {
                            showPopover(
                              context: context,
                              direction: PopoverDirection.top,
                              bodyBuilder: (context) => Labelslist(
                                updateUI: () {
                                  setState(() {});
                                },
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                          ),
                          child: Row(
                            children: [
                              Transform.rotate(
                                angle: pi * 0.25,
                                child: Icon(
                                  Icons.label,
                                  size: 18,
                                ),
                              ),
                              Text(
                                ' Label',
                                style:
                                    TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12, right: 12, top: 20),
                    child: SizedBox(
                      height: 25,
                      width: 60,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7))),
                        ),
                        onPressed: (title != null && title!.trim().isNotEmpty)
                            ? SaveTask
                            : null,
                        child:  Text(
                          'Save',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SaveTask() {
    DateTime now = DateTime.now();
    if (reminder2.isBefore(now)) {
      reminder2 = reminder2.add(
        Duration(days: 1),
      );
    }
    DateTime time_now = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    if (MainData.ReminderId > 1000) {
      MainData.ReminderId = 7;
    }
    context.pop(
      ToDo(
        _title_controller.text,
        _note_controller.text,
        false,
        MainData.saved,
        time_now,
        reminder2,
        MainData.ReminderId++,
        MainData.flag,
      ),
    );
    MainData.saved = false;
  }
}

Future<void> allowAlarm(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 17,
              bottom: 10,
              left: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Allow notifications?",
                style: TextStyle(
                  fontSize: 20, fontWeight: Device.menuFont
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 12, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10),                      shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                  ),
                  onPressed: () => {
                    context.pop(),
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 15, fontWeight: Device.menuFont
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10),                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                  ),
                  onPressed: () async => {
                    Device.settingsVisited = true,
                    await AppSettings.openAppSettings(
                        type: AppSettingsType.notification),
                    if (context.mounted)
                      {
                        context.pop(),
                      }
                  },
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 15, fontWeight: Device.menuFont
                    ),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
