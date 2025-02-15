import 'package:to_do_list/dialogs/NewTaskDialog.dart';
import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/models/widgets/LabelsList.dart';
import 'package:to_do_list/models/widgets/TimePicker.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'dart:math';

class TaskDialog extends StatefulWidget {
  final ToDo task;
  const TaskDialog({super.key, required this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _title_controller;
  late TextEditingController _note_controller;
  bool titleChanged = false;
  bool noteChanged = false;
  bool timeChanged = false;
 TimeOfDay reminder1 = TimeOfDay.now();
  DateTime reminder2 = DateTime.now();
  @override
  void initState() {
    super.initState();
    _title_controller = TextEditingController(text: widget.task.title);
    _note_controller = TextEditingController(text: widget.task.description);
    MainData.flag = widget.task.label;
    titleChanged = false;
    noteChanged = false;
    timeChanged = false;
    MainData.labelChanged = false;
    MainData.saved = widget.task.ReminderOn;
    reminder2=widget.task.timeReminder;
  }

  @override
  void dispose() {
    super.dispose();
    MainData.saved=false;
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
                          right: Device.pixelRatio*1, top: Device.pixelRatio*1),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => {
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
                      titleChanged = true;
                    },
                  ),
                  controller: _title_controller,
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 23,
                      color: Theme.of(context).colorScheme.tertiary, fontWeight: Device.menuFont
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                        left: 20,
                        bottom: 2,
                        top: 0,
                        right: Device.pixelRatio * 7),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Title',
                  ),
                ),
                TextFormField(
                  onChanged: (value) => setState(
                    () {
                      noteChanged = true;
                    },
                  ),
                  controller: _note_controller,
                  style:  TextStyle(
                    fontSize: 17, fontWeight: Device.menuFont,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.tertiary,
                         fontWeight: Device.menuFont),
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                        left: 26, top: 2, right: Device.pixelRatio * 17),
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
                    left: Device.pixelRatio * 3,
                    top: Device.pixelRatio*1,
                    bottom: Device.pixelRatio*1,
                  ),
                  child: Row(
                    children: [
                      if (MainData.saved)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            onTap: () {
                              setState(() {
                                timeChanged = true;
                                MainData.saved = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Device.pixelRatio * 4,
                                vertical: Device.pixelRatio*1,
                              ),
                              child: Text(
                                "${reminder2.hour.toString().padLeft(2, "0")}:${reminder2.minute.toString().padLeft(2, "0")}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryFixed, fontWeight: Device.menuFont,
                                    fontSize: Device.pixelRatio * 5),
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
                                MainData.labelChanged = true;
                                MainData.flag = "";
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Device.pixelRatio * 4,
                                vertical: Device.pixelRatio*1,
                              ),
                              child: Text(
                                MainData.flag,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed,
                                  fontSize: Device.pixelRatio * 5, fontWeight: Device.menuFont
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Device.pixelRatio * 13,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: TextButton(
                          onPressed: () async {
                            if (await isAlarmAllowed()) {
                              if (context.mounted) {
                                reminder1 = await selectTime(context,
                                    widget.task.timeReminder.toString());
                              }
                              if (MainData.saved) {
                                setState(() {
                                  reminder2 = DateTime(
                                    reminder2.year,
                                    reminder2.month,
                                    reminder2.day,
                                    reminder1.hour,
                                    reminder1.minute,
                                  );
                                  timeChanged = true;
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
                                size: Device.pixelRatio * 6,
                              ),
                              Text(
                                ' Reminder',
                                style: TextStyle(fontSize: 15),
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
                                  updateUI: () => setState(() {}),
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
                                    size: Device.pixelRatio * 6,
                                  ),
                                ),
                                Text(
                                  ' Label',
                                  style: TextStyle(fontSize: 15),
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
                                  BorderRadius.all(Radius.circular(7)),
                            ),
                          ),
                          onPressed:
                              ((_title_controller.text.trim().isNotEmpty) &&
                                      (titleChanged ||
                                          noteChanged ||
                                          timeChanged ||
                                          MainData.labelChanged))
                                  ? SaveTask
                                  : null,
                          child:  Text(
                            'Save',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void SaveTask() {
    context.pop(
      ToDo(
        _title_controller.text,
        _note_controller.text,
        widget.task.completed,
        MainData.saved,
        widget.task.creationDate,
        reminder2,
        widget.task.reminderId,
        MainData.flag,
      ),
    );

  }
}
