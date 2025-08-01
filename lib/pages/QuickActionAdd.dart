import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickActionsAdd extends StatefulWidget {
  const QuickActionsAdd({super.key});

  @override
  State<QuickActionsAdd> createState() => _QuickActionsAddState();
}

class _QuickActionsAddState extends State<QuickActionsAdd> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showQuickActionDialog(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
    );
  }
}

void showQuickActionDialog(BuildContext context) async {
  await fetchReminerId('maindata');
  if(context.mounted){

  ToDo? newTask = await displayNewTaskDialog(context);
  await validate_newTaskAdded(newTask, -1);
  }

  SystemNavigator.pop();
}

Future<void> validate_newTaskAdded(ToDo? newTask, int index) async {
  if (newTask != null) {
    await insertInDb('Inbox', newTask);

    if (index == -1) {
      MainData.inbox_tasks_list.add(newTask);
    } else {
      addDraggedTask(index, newTask);
    }
    UpdateInboxProgress();

    await sqlDB.deleteAll('Inbox');
    for (var element in MainData.inbox_tasks_list) {
      await insertInDb('Inbox', element);
    }
    await sqlDB.update(
      'maindata',
      {
        'ReminderId': MainData.ReminderId,
      },
      'id=?',
      [1],
    );
  }
}

void addDraggedTask(int index, ToDo newTask) {
  MainData.inbox_tasks_list.insert(index, newTask);
}
