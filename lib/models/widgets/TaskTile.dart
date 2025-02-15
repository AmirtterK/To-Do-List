import 'package:animated_line_through/animated_line_through.dart';
import 'package:to_do_list/dialogs/TaskDialog.dart';
import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/maps.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

// ignore: must_be_immutable
class TaskTile extends StatefulWidget {
  ToDo task;
  VoidCallback delete;
  String section;
  int index;
  TaskTile({
    required this.index,
    required this.task,
    required this.delete,
    super.key,
    required this.section,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    String table = '${widget.section}todos';
    return ListTile(
      trailing: null,
      dense: true,
      onTap: () async {
        ToDo? Modified = await showGeneralDialog(
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          anchorPoint: Offset.zero,
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SizedBox(),
          transitionDuration: const Duration(milliseconds: 120),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                child: TaskDialog(task: widget.task),
              ),
            );
          },
        );
        if (Modified != null && task_changed(widget.task, Modified)) {
          if (Modified.ReminderOn && !Device.desktopPlatform) {
            Workmanager().registerOneOffTask(
                widget.task.reminderId.toString(), "notification",
                inputData: TodoMap(Modified),
                existingWorkPolicy: ExistingWorkPolicy.update);
          }
          await sqlDB.update(table, TodoMap(Modified), 'creationDate=?',
              [widget.task.creationDate.toString()]);
          setState(
            () {
              widget.task = Modified;
              MainData.selectedList[widget.index] = Modified;
            },
          );
        }
      },
      contentPadding: const EdgeInsets.only(left: 17),
      key: const ObjectKey(ListTile),
      title: Padding(
        padding: EdgeInsets.only(right: Device.pixelRatio * 8),
        child: Row(
          children: [
            Container(
              width: (Device.screenWidth * 0.083).round() * 1,
              height: (Device.screenHeight * 0.038).round() * 1,
              constraints: const BoxConstraints(),
              child: Checkbox(
                side: BorderSide(
                  color: Colors.grey.shade500.withValues(
                    alpha: 0.95,
                  ),
                  width: 2,
                ),
                value: widget.task.completed,
                fillColor:
                    WidgetStateProperty.resolveWith((_) => Colors.transparent),
                checkColor: Theme.of(context).colorScheme.secondaryFixed,
                onChanged: (value) async {
                  setState(
                    () {
                      widget.task.completed = value!;
                      switch (widget.section) {
                        case 'Inbox':
                          if (widget.task.completed) {
                            MainData.completed_inbox_tasks++;
                            UpdateInboxProgress();
                          } else {
                            MainData.completed_inbox_tasks--;
                            UpdateInboxProgress();
                          }
                          break;
                        case 'Today':
                          if (widget.task.completed) {
                            MainData.completed_Today_tasks++;
                            UpdateTodayProgress();
                          } else {
                            MainData.completed_Today_tasks--;
                            UpdateTodayProgress();
                          }
                          break;

                        default:
                      }
                    },
                  );
                  if (widget.task.ReminderOn && widget.task.completed) {
                    await cancelNotification(widget.task.reminderId);
                  }
                  if (widget.task.ReminderOn && !widget.task.completed) {
                    await Workmanager().registerOneOffTask(
                        widget.task.reminderId.toString(), "notification",
                        inputData: TodoMap(widget.task));
                  }
                  await sqlDB.update(table, TodoMap(widget.task),
                      'creationDate=?', [widget.task.creationDate.toString()]);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: (Device.screenWidth * 0.0166).round() * 1),
                child: AnimatedLineThrough(
                  duration: Duration(milliseconds: 250),
                  strokeWidth: 2,
                  isCrossed: widget.task.completed,
                  child: Text(
                    widget.task.title,
                    style: TextStyle(fontSize: 18, fontWeight: Device.menuFont),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: (widget.task.description.isNotEmpty)
          ? Padding(
              padding: EdgeInsets.only(
                  left: Device.pixelRatio * 15, right: Device.pixelRatio * 20),
              child: Text(
                widget.task.description,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: Device.menuFont),
              ),
            )
          : null,
    );
  }
}
