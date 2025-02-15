import 'package:flutter/material.dart';
import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import '../models/widgets/TaskTile.dart';
import '../models/widgets/Appbar.dart';
import '../services/database/AppData.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  String Pagetitle = 'Archive';
  late ToDo RestoreTask;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: Appbar(title: Pagetitle),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ReorderableListView.builder(
                itemCount: MainData.archived_tasks_list.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ObjectKey(MainData.archived_tasks_list[index]),
                    background: Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                    ),
                    secondaryBackground: Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                    ),
                    child: TaskTile(
                      index: index,
                      section: Pagetitle,
                      task: MainData.archived_tasks_list[index],
                      delete: () {
                        setState(
                          () {
                            MainData.archived_tasks_list.removeAt(index);
                          },
                        );
                      },
                    ),
                    onDismissed: (direction) async {
                      await removeFromDb(
                          'Archived', MainData.archived_tasks_list[index]);
                      setState(
                        () {
                          if (direction == DismissDirection.startToEnd) {
                            RestoreTask =
                                MainData.archived_tasks_list.removeAt(index);
                          } else {
                            RestoreTask =
                                MainData.archived_tasks_list.removeAt(index);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task deleted',
                                style: TextStyle(fontWeight: Device.menuFont),
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () async {
                                  await insertInDb('Archived', RestoreTask);
                                  setState(
                                    () {
                                      MainData.archived_tasks_list
                                          .insert(index, RestoreTask);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                onReorder: (int oldIndex, int newIndex) async {
                  setState(
                    () {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      final moved_task =
                          MainData.archived_tasks_list.removeAt(oldIndex);
                      MainData.archived_tasks_list.insert(newIndex, moved_task);
                    },
                  );
                  await sqlDB.deleteAll('Archived');
                  for (var element in MainData.archived_tasks_list) {
                    await insertInDb('Archived', element);
                  }
                },
              ),
            ),
          ],
        ),
      );
}
