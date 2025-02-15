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

void showQuickActionDialog(context) async {
  await fetchReminerId('maindata');
  ToDo? new_task = await displayNewTaskDialog(context);

  await validate_newTaskAdded(new_task, -1);
  SystemNavigator.pop();
}

Future<void> validate_newTaskAdded(ToDo? new_task, int index) async {
  if (new_task != null) {
    await insertInDb('Inbox', new_task);

    if (index == -1) {
      MainData.inbox_tasks_list.add(new_task);
    } else {
      addDraggedTask(index, new_task);
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

void addDraggedTask(index, ToDo new_task) {
  MainData.inbox_tasks_list.insert(index, new_task);
}
