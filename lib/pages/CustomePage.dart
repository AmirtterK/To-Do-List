import 'package:flutter/cupertino.dart';
import 'package:to_do_list/models/icons/customIcons.dart';
import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:to_do_list/models/widgets/DragTaskTarget.dart';
import 'package:to_do_list/models/widgets/TaskTile.dart';
import 'package:to_do_list/models/classes/taskClass.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import 'package:to_do_list/services/quickActions/quickActions.dart';
import 'package:flutter/material.dart';

class Customepage extends StatefulWidget {
  final String location;
  const Customepage(this.location, {super.key});

  @override
  State<Customepage> createState() => _CustomepageState();
}

class _CustomepageState extends State<Customepage> with WidgetsBindingObserver {
  QuickActionsMenu quickActions = QuickActionsMenu();

  late final String _Pagetitle;
  late ToDo RestoreTask;
  bool isDragged = false;
  bool hover = false;

  Future<void> addDraggedTask(int index, ToDo new_task) async {
    setState(
      () {
        MainData.selectedList.insert(index, new_task);
      },
    );
    await sqlDB.deleteAll(_Pagetitle);
    for (var element in MainData.selectedList) {
      await insertInDb(_Pagetitle, element);
    }
  }

  Future<void> validate_newTaskAdded(ToDo? new_task, int index) async {
    if (new_task != null) {
      await insertInDb(_Pagetitle, new_task);
      setState(
        () {
          if (index == -1) {
            MainData.selectedList.add(new_task);
          } else {
            addDraggedTask(index, new_task);
          }
          switch (_Pagetitle) {
            case 'Inbox':
              UpdateInboxProgress();
              break;
            case 'Today':
              UpdateTodayProgress();
              break;
            default:
          }
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _Pagetitle = widget.location;
    quickActions.init(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      MainData.selectedList.clear();
      await fetchData('${_Pagetitle}Todos', MainData.selectedList);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Appbar(
            title: _Pagetitle.replaceAll('_', ' ').replaceAll('dotmark', '.')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: MainData.selectedList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        key: ValueKey(index),
                        children: [
                          DragTaskTarget(
                            onTaskDropped: (index) async {
                              ToDo? new_task =
                                  await displayNewTaskDialog(context);
                              validate_newTaskAdded(new_task, index);
                            },
                            dialogClosed: () => setState(() {}),
                            index: index,
                            child: SizedBox(),
                          ),
                          Dismissible(
                            background: Icon(
                              Icons.delete_sweep,
                              color: Colors.red,
                            ),
                            secondaryBackground: Icon(
                              CustomIcons.archive,
                              color: Colors.green,
                            ),
                            direction: DismissDirection.horizontal,
                            key: ObjectKey(MainData.selectedList[index]),
                            child: TaskTile(
                              index: index,
                              section: _Pagetitle,
                              task: MainData.selectedList[index],
                              delete: () {
                                setState(
                                  () {
                                    MainData.selectedList.removeAt(index);
                                  },
                                );
                              },
                            ),
                            onDismissed: (direction) async {
                              await removeFromDb(
                                  _Pagetitle, MainData.selectedList[index]);

                              if (direction == DismissDirection.endToStart) {
                                await insertInDb(
                                    'Archived', MainData.selectedList[index]);
                              }
                              setState(
                                () {
                                  if (MainData.selectedList[index].completed) {
                                    switch (_Pagetitle) {
                                      case 'Inbox':
                                        MainData.completed_inbox_tasks--;
                                        break;
                                      case 'Today':
                                        MainData.completed_Today_tasks--;
                                        break;
                                      default:
                                    }
                                  }
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    RestoreTask =
                                        MainData.selectedList.removeAt(index);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Task deleted',
                                            style: TextStyle(),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () async {
                                              setState(
                                                () {
                                                  MainData.selectedList.insert(
                                                      index, RestoreTask);
                                                  if (MainData
                                                      .selectedList[index]
                                                      .completed) {
                                                    MainData
                                                        .completed_Today_tasks++;
                                                  }
                                                  switch (_Pagetitle) {
                                                    case 'Inbox':
                                                      UpdateInboxProgress();
                                                      break;
                                                    case 'Today':
                                                      UpdateTodayProgress();

                                                      break;
                                                    default:
                                                  }
                                                },
                                              );
                                              await sqlDB.deleteAll(_Pagetitle);
                                              for (var element
                                                  in MainData.selectedList) {
                                                await insertInDb(
                                                    _Pagetitle, element);
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    MainData.archived_tasks_list
                                        .add(MainData.selectedList[index]);
                                    RestoreTask =
                                        MainData.selectedList.removeAt(index);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Task archived',
                                            style: TextStyle(),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () async {
                                              await removeFromDb(
                                                  'Archived', RestoreTask);
                                              setState(
                                                () {
                                                  MainData.archived_tasks_list
                                                      .removeLast();
                                                  MainData.selectedList.insert(
                                                      index, RestoreTask);
                                                  if (MainData
                                                      .selectedList[index]
                                                      .completed) {
                                                    switch (_Pagetitle) {
                                                      case 'Inbox':
                                                        MainData
                                                            .completed_inbox_tasks++;
                                                        UpdateInboxProgress();
                                                        break;
                                                      case 'Today':
                                                        MainData
                                                            .completed_Today_tasks++;
                                                        UpdateTodayProgress();
                                                        break;
                                                      default:
                                                    }
                                                  }
                                                },
                                              );
                                              await sqlDB.deleteAll(_Pagetitle);
                                              for (var element
                                                  in MainData.selectedList) {
                                                await insertInDb(
                                                    _Pagetitle, element);
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  }

                                  switch (_Pagetitle) {
                                    case 'Inbox':
                                      UpdateInboxProgress();
                                      break;
                                    case 'Today':
                                      UpdateTodayProgress();

                                      break;
                                    default:
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) async {
                      setState(
                        () {
                          if (oldIndex < newIndex) {
                            newIndex--;
                          }
                          RestoreTask =
                              MainData.selectedList.removeAt(oldIndex);
                          MainData.selectedList.insert(newIndex, RestoreTask);
                        },
                      );
                      await sqlDB.deleteAll(_Pagetitle);
                      for (var element in MainData.selectedList) {
                        await insertInDb(_Pagetitle, element);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Draggable<int>(
          data: 0,
          childWhenDragging: Container(),
          onDragStarted: () => setState(
            () {
              isDragged = true;
            },
          ),
          onDraggableCanceled: (velocity, offset) => setState(
            () {
              isDragged = false;
            },
          ),
          onDragEnd: (details) => setState(
            () {
              isDragged = false;
            },
          ),
          feedback: FloatingActionButton(
            onPressed: () {},
            shape: const CircleBorder(),
            elevation: 3,
            child: Icon(
              CupertinoIcons.add,
              size: 36,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 17,
              right: 3,
            ),
            child: FloatingActionButton(
              onPressed: () async {
                ToDo? new_task = await displayNewTaskDialog(context);
                await validate_newTaskAdded(new_task, -1);
              },
              shape: const CircleBorder(),
              elevation: 3,
              child: Icon(
                CupertinoIcons.add,
                size: 36,
              ),
            ),
          ),
        ),
      );
}
