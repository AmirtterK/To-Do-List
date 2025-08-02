// ignore_for_file: file_names, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_list/models/classes/customListClass.dart';
import 'package:to_do_list/models/classes/menuClass.dart';
import 'package:to_do_list/models/icons/customIcons.dart';
import 'package:to_do_list/pages/CustomePage.dart';
import 'package:to_do_list/services/database/AppData.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onUpdate;
  const Appbar({super.key, required this.title, this.onUpdate});

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class _AppbarState extends State<Appbar> {
  Icon icon = Icon(
    Icons.menu_rounded,
    size: 32,
    weight: 500,
  );
  @override
  void initState() {
    super.initState();
    print(widget.title);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    switch (widget.title) {
      case "Theme":
        icon = Icon(
          Icons.arrow_back_rounded,
          size: 32,
          weight: 500,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        );
        break;
      case "Pomodoro":
        icon = Icon(
          Icons.arrow_back_rounded,
          size: 32,
          weight: 500,
          color: const Color.fromARGB(255, 255, 255, 255),
        );
        break;
      case "Editpomodoro":
        icon = Icon(
          Icons.arrow_back_rounded,
          size: 32,
          weight: 500,
          color: const Color.fromARGB(255, 255, 255, 255),
        );
        break;
      case "Settings":
        icon = Icon(
          Icons.arrow_back_rounded,
          size: 32,
          weight: 500,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        );
        break;

      case "Home":
        icon = Icon(
          Icons.person,
          size: 28,
          weight: 500,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        );
        break;
      default:
        Icon(
          Icons.menu_rounded,
          size: 32,
          weight: 500,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: Device.desktopPlatform
          ? null
          : IconButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () => {
                setState(() {
                  switch (widget.title) {
                    case "Home":
                      null;
                      break;
                    case "Editpomodoro":
                      context.pop();
                      break;
                    case "Theme":
                      context.pop();
                      break;
                    default:
                      context.pop();
                      break;
                  }
                })
              },
              icon: icon,
            ),
      title: Text(
        widget.title == "Editpomodoro" ? "" : widget.title,
        style: widget.title == "Pomodoro"
            ? TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: Device.menuFont)
            : TextStyle(fontSize: 20, fontWeight: Device.menuFont),
      ),
      actions: [
        (widget.title == "Home" && !Device.desktopPlatform)
            ? IconButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Customlist? newList = await displayNewListDialog(context);
                  setState(
                    () {
                      if (newList != null) {
                        sqlDB.createNewTable(newList.ListName);
                        sqlDB
                            .insert("customeList", {'title': newList.ListName});
                        int index = MainData.MenuItems.indexWhere(
                            (item) => item.location == 'Archive');
                        MainData.MenuItems.insert(
                          index,
                          MenuItem(
                            Text(
                              newList.ListName.replaceAll('_', ' ')
                                  .replaceAll('dotmark', '.'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: Device.menuFont,
                              ),
                            ),
                            Icon(
                              CustomIcons.list,
                              size: 28,
                            ),
                            newList.ListName,
                          ),
                        );
                        MainData.customlist.add(newList);
                      }

                      if (widget.onUpdate != null) {
                        widget.onUpdate!();
                      }
                    },
                  );
                },
                icon: Icon(
                  Icons.add_sharp,
                  size: 32,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
              )
            : SizedBox(),
        !(widget.title == "Inbox" ||
                widget.title == "Today" ||
                widget.title == "Pomodoro" ||
                widget.title == "Archive" ||
                widget.title == "Settings" ||
                widget.title == "Home" ||
                widget.title == "Theme" ||
                widget.title == "Editpomodoro")
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  onPressed: () async {
                    await sqlDB.deleteTable(
                        "${widget.title.replaceAll(' ', '_').replaceAll('.', 'dotmark')}Todos");
                    MainData.MenuItems.removeWhere((item) =>
                        item.location ==
                        widget.title
                            .replaceAll(' ', '_')
                            .replaceAll('.', 'dotmark'));
                    await sqlDB.delete("customeList", 'title=?', [
                      widget.title
                          .replaceAll(' ', '_')
                          .replaceAll('.', 'dotmark')
                    ]);
                    for (var task in MainData.selectedList) {
                      if (task.ReminderOn &&
                          MainData.isAllarmOn &&
                          task.timeReminder.isAfter(DateTime.now())) {
                        await cancelNotification(task.reminderId);
                      }
                    }
                    MainData.customlist.removeWhere((Clist) =>
                        Clist.ListName ==
                        widget.title
                            .replaceAll(' ', '_')
                            .replaceAll('.', 'dotmark'));
                    if (context.mounted) {
                      if (Device.desktopPlatform) {
                        MainData.selectedList = MainData.inbox_tasks_list;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Customepage('Inbox')),
                        );
                      } else {
                        if (widget.onUpdate != null) {
                          widget.onUpdate!();
                        }

                        context.pop();
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.delete_sweep,
                    size: 32,
                    color: Theme.of(context).colorScheme.secondaryFixed,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
