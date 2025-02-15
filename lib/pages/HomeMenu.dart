import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import '../services/database/AppData.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> with WidgetsBindingObserver {
  final String _Pagetitle = 'Home';
  bool _menuUpdated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateInboxProgressIndicators();
    updateTodayProgressIndicators();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateUi() {
    setState(() {
      _menuUpdated = !_menuUpdated;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      await fetchMainData(
        'MainData',
      );
      updateInboxProgressIndicators();
      updateInboxProgressIndicators();
      setState(
        () {
          _menuUpdated = !_menuUpdated;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Device.desktopPlatform
          ? null
          : Appbar(
              title: _Pagetitle,
              onUpdate: updateUi,
            ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              key: ValueKey(_menuUpdated),
              padding: EdgeInsets.only(top: Device.pixelRatio * 2),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MainData.MenuItems.length,
              itemBuilder: (BuildContext context, int index) {
                if (MainData.MenuItems[index].location == 'Archive' ||
                    index == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15,
                                bottom: 7,
                                top: Device.pixelRatio * 3),
                            child: Text(
                              "General",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed,
                                  fontSize: Device.pixelRatio * 6,
                                  fontWeight: Device.menuFont),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 58, 58, 58)
                                  : const Color.fromARGB(255, 211, 211, 211),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15,
                                    bottom: 7,
                                    top: Device.pixelRatio * 3),
                                child: Text(
                                  "Other",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryFixed,
                                      fontSize: 18,
                                      fontWeight: Device.menuFont),
                                ),
                              ),
                            )
                          ],
                        ),
                      ListTile(
                        onTap: () async => {
                          if (MainData.MenuItems[index].location == 'Inbox')
                            {
                              MainData.selectedList = MainData.inbox_tasks_list,
                            },
                          context
                              .pushNamed(MainData.MenuItems[index].location)
                              .then((_) => setState(() {
                                    _menuUpdated = !_menuUpdated;
                                  })),
                        },
                        leading: Padding(
                          padding: EdgeInsets.only(left: Device.pixelRatio * 3),
                          child: Transform.scale(
                            scale: index == 0 ? 1.14 : 1,
                            child: IconTheme(
                              data: IconThemeData(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryFixed,
                              ),
                              child: MainData.MenuItems[index].icon,
                            ),
                          ),
                        ),
                        title: MainData.MenuItems[index].content,
                      ),
                    ],
                  );
                }
                return ListTile(
                  onTap: () async => {
                    if (MainData.MenuItems[index].location == 'Settings' ||
                        MainData.MenuItems[index].location == 'Pomodoro')
                      {
                        context
                            .pushNamed(MainData.MenuItems[index].location)
                            .then((_) => setState(() {
                                  _menuUpdated = !_menuUpdated;
                                })),
                      }
                    else if (MainData.MenuItems[index].location == 'Today')
                      {
                        MainData.selectedList = MainData.Today_tasks_list,
                        context
                            .pushNamed(MainData.MenuItems[index].location)
                            .then((_) => setState(() {
                                  _menuUpdated = !_menuUpdated;
                                })),
                      }
                    else
                      {
                        MainData.selectedList = MainData
                            .customlist[MainData.customlist.indexWhere(
                                (Clist) =>
                                    Clist.ListName ==
                                    MainData.MenuItems[index].location)]
                            .list,
                        await context.pushNamed(
                          'Custome',
                          queryParameters: {
                            'pagetitle': MainData.MenuItems[index].location
                          },
                        ).then((_) => setState(() {
                              _menuUpdated = !_menuUpdated;
                            }))
                      }
                  },
                  leading: Padding(
                    padding: EdgeInsets.only(left: Device.pixelRatio * 3),
                    child: IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                      child: MainData.MenuItems[index].icon,
                    ),
                  ),
                  title: MainData.MenuItems[index].content,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
